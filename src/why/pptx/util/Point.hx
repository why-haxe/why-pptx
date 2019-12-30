package why.pptx.util;

abstract Point(Float) from Float to Float {
	public static inline function cm(v:Float):Point return inch(v * 0.393700787);
	public static inline function inch(v:Float):Point return v * 72;
	
	public inline function toInch():Float return this / 72;
	public inline function toPoint():Float return this;
	
	@:op(a-b) function sub(b:Float):Float;
}
