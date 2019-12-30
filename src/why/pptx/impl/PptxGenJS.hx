package why.pptx.impl;

import haxe.extern.EitherType;

@:native('PptxGenJS')
extern class PptxGenJS {
	var layout:String;
	function new();
	function defineLayout(opt:{name:String, width:Float, height:Float}):Void;
	function defineSlideMaster(opts:SlideMasterOptions):Void;
	function addSlide(opts:{}):Slide;
	function writeFile(?name:String):Void;
}
private extern class Slide {
	function addText(text:String, opts:{}):Void;
}
private typedef Margin = EitherType<Float, Array<Float>>;
private typedef SlideMasterOptions = {
	title:String,
	?height:Float,
	?width:Float,
	?margin:Margin,
	?bkgd:String,
	?objects: Array<Dynamic>, // { chart: {} } | { image: {} } | { line: {} } | { rect: {} } | { text: { options: ITextOpts } } | { placeholder: { options: ISlideMstrObjPlchldrOpts; text?: string } }
	?slideNumber:Dynamic, // ISlideNumber
}