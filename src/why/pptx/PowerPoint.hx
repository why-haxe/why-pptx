package why.pptx;

import why.pptx.util.*;

using why.pptx.util.Point;

class PowerPoint {
	public static function generate(def:PresentationDef) {
		
		var pptx = new why.pptx.impl.PptxGenJS();
		pptx.defineLayout({name: 'custom', width: def.size.w.toInch(), height: def.size.h.toInch()});
		pptx.layout = 'custom';
		for (master in def.masters) {
			pptx.defineSlideMaster({
				title: master.name,
				bkgd: 'FFFFFF',
				objects: [
					for (object in master.objects)
						switch object {
							case Image(def):
								{
									image: {
										data: '${def.mime};base64,${haxe.crypto.Base64.encode(def.data)}',
										x: def.layout.x.toInch(),
										y: def.layout.y.toInch(),
										w: def.layout.w.toInch(),
										h: def.layout.h.toInch(),
										sizing: switch def.sizing {
											case Contain(w, h): {type: 'contain', w: w.toInch(), h: h.toInch()}
											case Cover(w, h): {type: 'cover', w: w.toInch(), h: h.toInch()}
											case Crop(x, y, w, h): cast {type: 'crop', x: x.toInch(), y: y.toInch(), w: w.toInch(), h: h.toInch()}
										}
									}
								}
							case Text(def):
								{
									text: {
										text: def.value,
										options: {
											x: def.layout.x.toInch(),
											y: def.layout.y.toInch(),
											w: def.layout.w.toInch(),
											h: def.layout.h.toInch(),
											fontFace: 'DFWeiBei-B5',
											fontSize: def.size.toPoint(),
											align: def.align.horizonal,
											valign: def.align.vertical,
											color: def.color,
											glow: def.glow,
											margin: [def.margin.l.toPoint(), def.margin.r.toPoint(), def.margin.b.toPoint(), def.margin.t.toPoint()],
										}
									}
								}
							case Placeholder(def):
								{
									placeholder: {
										text: def.value,
										options: {
											name: def.name,
											type: def.type,
											x: def.layout.x.toInch(),
											y: def.layout.y.toInch(),
											w: def.layout.w.toInch(),
											h: def.layout.h.toInch(),
											fontFace: 'DFWeiBei-B5',
											fontSize: def.size.toPoint(),
											align: def.align.horizonal,
											valign: def.align.vertical,
											color: def.color,
											glow: def.glow,
											margin: [def.margin.l.toPoint(), def.margin.r.toPoint(), def.margin.b.toPoint(), def.margin.t.toPoint()],
										},
									}
								}
						}
				]
			});
		}
		
		for(slide in def.slides) {
			var s = pptx.addSlide(slide.master);
			for(object in slide.objects) switch object {
				case Text(def):
				s.addText(def.value, {
					placeholder: def.placeholder,
				});
			}
		}

		pptx.writeFile();
	}
}


typedef PresentationDef = {
	size:Size,
	masters:Array<MasterDef>,
	slides:Array<SlideDef>,
}

typedef SlideDef = {
	?master:String,
	objects:Array<SlideObjectType>,
}

enum SlideObjectType {
	Text(def:SlideTextDef);
}

typedef MasterDef = {
	name:String,
	objects:Array<MasterObjectType>,
}

enum MasterObjectType {
	Image(def:ImageDef);
	Text(def:TextDef);
	Placeholder(def:PlaceholderDef);
}

typedef ObjectDef = {
	layout:Layout,
}


typedef TextDef = ObjectDef & {
	value:String,
	color:Color,
	glow:Glow,
	size:Point,
	margin:Margin,
	align: {
		horizonal:HorizonalAlign,
		vertical:VerticalAlign,
	}
}

typedef SlideTextDef = {
	value:String,
	?placeholder:String,
}

typedef PlaceholderDef = TextDef & {
	name:String,
	type:String,
};

typedef ImageDef = ObjectDef & {
	mime:String,
	data:haxe.io.Bytes,
	sizing:ImageSizing,
}

enum abstract HorizonalAlign(String) to String {
	var Left = 'left';
	var Center = 'center';
	var Right = 'right';
	// var Justified = 'justified';
}

enum abstract VerticalAlign(String) to String {
	var Top = 'top';
	var Middle = 'middle';
	var Bottom = 'bottom';
}

typedef Glow = {
	color:Color,
	size:Point,
	opacity:Float,
};

enum ImageSizing {
	Contain(width:Point, height:Point);
	Cover(width:Point, height:Point);
	Crop(x:Point, y:Point, width:Point, height:Point);
}

