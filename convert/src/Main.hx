import LatexParser;

using StringTools;
using Lambda;

typedef SectionInfo = {
	all: Array<Section>,
	unreviewed: Array<String>,
	modified: Array<String>,
	noContent: Array<Section>
}

class Main {
	static function main() {
		new Main();
	}

	var parser:LatexParser;
	var out:String;
	var sectionInfo:SectionInfo;

	function new() {
		Sys.setCwd("../");
		var sections = parse();
		out = #if epub "md_epub/manual" #else "md/manual" #end;

		sectionInfo = collectSectionInfo(sections);

		for (sec in sectionInfo.all) {
			if (sec.content.length == 0 && sec.sub.length > 0) {
				sec.content = sec.sub.map(function(sec) return sec.id + ": " +link(sec)).join("\n\n");
			} else {
				sec.content = process(sec.content);
			}
		}

		function generateTitleString(sec:Section, prefix = "##") {
			return
				#if epub '<a id="${url(sec)}"></a>\n' + #end
				'$prefix ${sec.id} ${sec.title}\n\n';
		}

		for (sec in sectionInfo.all) {
			if (sec.flags["fold"] == "true") {
				for (sub in sec.sub) {
					sec.content += "\n\n" + generateTitleString(sub, "###") + sub.content;
					sectionInfo.all.remove(sub);
					Reflect.deleteField(sub, "content");
				}
			}
		}

		unlink(out);
		sys.FileSystem.createDirectory(out);

		for (i in 0...sectionInfo.all.length) {
			var sec = sectionInfo.all[i];
			sec.content = generateTitleString(sec) + sec.content + "\n";
			#if !epub
			sec.content += "\n---";
			if (i != 0) sec.content += '\n\nPrevious section: ${link(sectionInfo.all[i - 1])}';
			if (i != sectionInfo.all.length - 1) sec.content += '\n\nNext section: ${link(sectionInfo.all[i + 1])}';
			#end
			sys.io.File.saveContent('$out/${url(sec)}', sec.content);
			Reflect.deleteField(sec, "content");
		}
		generateDictionary();
		generateTodo();
		sys.io.File.saveContent('$out/sections.txt', haxe.Json.stringify(sections));

		#if epub
		generateEPub();
		#end

		#if mobi
			#if !epub
			#error "Generating .mobi requires -D epub to be defined"
			#end
			Sys.command("ebook-convert", ["HaxeManual.epub", "HaxeManual.mobi", "--no-inline-toc"]);
		#end
	}

	function parse() {
		LatexLexer.customEnvironments["flowchart"] = FlowchartHandler.handle;
		var input = byte.ByteData.ofString(sys.io.File.getContent("HaxeDoc.tex"));
		parser = new LatexParser(input, "HaxeDoc.tex");
		var sections = try {
			parser.parse();
		} catch(e:hxparse.NoMatch<Dynamic>) {
			throw e.pos.format(input) + ": Unexpected " +e.token;
		} catch(e:hxparse.Unexpected<Dynamic>) {
			throw e.pos.format(input) + ": Unexpected " +e.token;
		}
		return sections;
	}

	function collectSectionInfo(sections:Array<Section>):SectionInfo {
		var allSections = [];
		var unreviewed = [];
		var modified = [];
		var noContent = [];

		function add(sec:Section) {
			if (sec.label == null) {
				throw 'Missing label: ${sec.title}';
			}
			if(sec.content.length == 0) {
				if (sec.state != NoContent) {
					noContent.push(sec);
				}
				if (sec.sub.length == 0) {
					return;
				}
			} else switch(sec.state) {
				case New: unreviewed.push('${sec.id} - ${sec.title}');
				case Modified: modified.push('${sec.id} - ${sec.title}');
				case Reviewed | NoContent:
			}
			allSections.push(sec);
			for (sec in sec.sub) {
				add(sec);
			}
		}
		for (sec in sections) {
			add(sec);
		}
		return {
			all: allSections,
			unreviewed: unreviewed,
			noContent: noContent,
			modified: modified
		}
	}

	function generateDictionary() {
		var entries = parser.definitions;
		entries.sort(function(v1, v2) return Reflect.compare(v1.title.toLowerCase(), v2.title.toLowerCase()));
		var definitions = [];
		for (entry in entries) {
			var anchorName = #if epub "dictionary.md-" +entry.label #else entry.label #end;
			definitions.push('<a id="$anchorName" class="anch"></a>\n\n##### ${entry.title}\n${process(entry.content)}');
		}
		sys.io.File.saveContent('$out/dictionary.md', definitions.join("\n\n"));
	}

	function generateTodo() {
		var todo = "This file is generated, do not edit!\n\n"
			+ "Todo:\n" + parser.todos.join("\n") + "\n\n"
			+ "Missing Content:\n" + sectionInfo.noContent.map(function(sec) return '${sec.id} - ${sec.title}').join("\n") + "\n\n"
			+ "Unreviewed:\n" + sectionInfo.unreviewed.join("\n") + "\n\n"
			+ "Modified:\n" + sectionInfo.modified.join("\n");
		sys.io.File.saveContent('todo.txt', todo);
	}

	function generateEPub() {
		var files = sectionInfo.all.map(function(sec) return out + "/" + url(sec));
		Sys.command("pandoc", ["-t", "epub", "-f", "markdown_github", "-o", "HaxeManual.epub", "--table-of-contents", "--epub-metadata=epub_metadata.xml"].concat(files).concat(['$out/dictionary.md']));
	}

	function link(sec:Section) {
		if (sectionInfo.noContent.has(sec)) {
			return '${sec.title}';
		}
		return '[${sec.title}](${LatexParser.linkPrefix}${url(sec)})';
	}

	function process(s:String):String {
		function labelUrl(label:Label) {
			return switch(label.kind) {
				case Section(sec): url(sec);
				case Definition:
					#if epub
					'dictionary.md-${escapeAnchor(label.name)}';
					#else
					'dictionary.md#${escapeAnchor(label.name)}';
					#end
				case Item(i): "" + i;
				case Paragraph(sec, name): '${url(sec)}#${escapeAnchor(name)}';
			}
		}
		function labelLink(label:Label) {
			return switch(label.kind) {
				case Section(sec): link(sec);
				case Definition: '[${label.name}](${labelUrl(label)})';
				case Item(i): "" + i;
				case Paragraph(sec, name): '[$name](${url(sec)}#${escapeAnchor(name)})';
			}
		}
		function map(r, f) {
			var i = r.matched(1);
			if (!parser.labelMap.exists(i)) {
				trace('Warning: No such label $i');
				return i;
			}
			return f(parser.labelMap[i]);
		}
		var s1 = ~/~~~([^~]+)~~~/g.map(s, map.bind(_, labelLink));
		return ~/~~([^~]+)~~/g.map(s1, map.bind(_, labelUrl));
	}

	static function escapeFileName(s:String) {
		return s.replace("?", "").replace("/", "_").replace(" ", "_");
	}

	static function escapeAnchor(s:String) {
		return s.toLowerCase().replace(" ", "-");
	}

	static function url(sec:Section) {
		return sec.label + ".md";
	}

	static function unlink(path:String) {
		if(sys.FileSystem.exists(path)) {
			if(sys.FileSystem.isDirectory(path)) {
				for(entry in sys.FileSystem.readDirectory(path))  {
					unlink( path + "/" + entry );
				}
				sys.FileSystem.deleteDirectory(path);
			}
			else {
				sys.FileSystem.deleteFile(path);
			}
		}
	}
}
