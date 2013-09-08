import LatexParser;

using StringTools;
using Lambda;

class Main{
	static function main() {
		Sys.setCwd("../");
		var input = byte.ByteData.ofString(sys.io.File.getContent("HaxeDoc.tex"));
		var parser = new LatexParser(input, "HaxeDoc.tex");
		var sections = parser.parse();
		var out = "md/manual";
		var linkBase = "https://github.com/Simn/HaxeManual/tree/master/";
		function escapeFileName(s:String) {
			return s.replace("?", "").replace("/", "_").replace(" ", "_");
		}
		function url(sec:Section) {
			return sec.id + "-" +(escapeFileName(sec.title)) + ".md";
		}
		function link(sec:Section) {
			return '[${sec.title}]($linkBase$out/${url(sec)})';
		}
		function process(s:String):String {
			return ~/~~~([^~]+)~~~/g.map(s, function(r) {
				var i = r.matched(1);
				if (!parser.labelMap.exists(i)) {
					trace('Warning: No such label $i');
					return i;
				}
				return link(parser.labelMap[i]);
			});
		}
		sys.FileSystem.createDirectory(out);
		var allSections = [];
		function add(sec:Section) {
			sec.content = process(sec.content.trim());
			if(sec.content.length == 0) {
				if (sec.sub.length == 0) return;
				sec.content = sec.sub.map(function(sec) return sec.id + ": " +link(sec)).join("\n\n");
			}
			allSections.push(sec);
			for (sec in sec.sub) {
				add(sec);
			}
		}
		for (sec in sections) {
			add(sec);
		}
		for (i in 0...allSections.length) {
			var sec = allSections[i];
			var content = '## ${sec.id} ${sec.title}\n\n' + sec.content;
			content += "\n\n---";
			if (i != 0) content += '\n\nPrevious section: ${link(allSections[i - 1])}';
			if (i != allSections.length - 1) content += '\n\nNext section: ${link(allSections[i + 1])}';
			sys.io.File.saveContent('$out/${url(sec)}', content);
		}
		var a = [for (k in parser.definitionMap.keys()) {k:k, v:parser.definitionMap[k]}];
		a.sort(function(v1, v2) return Reflect.compare(v1.k.toLowerCase(), v2.k.toLowerCase()));
		sys.io.File.saveContent('$out/dictionary.md', a.map(function(v) return '##### ${v.k}\n${process(v.v)}').join("\n\n"));
	}
}