package why.pptx.util;

@:forward(mime, data)
@:pure
abstract Image(Obj) from Obj to Obj {
	public inline function new(mime, data)
		this = {
			mime: mime,
			data: data,
		}
	
	public function toDataUrl():String {
		if(this.dataUrl == null)
			this.dataUrl = 'data:${this.mime};base64,${haxe.crypto.Base64.encode(this.data)}';
		return this.dataUrl;
	}
}

private typedef Obj = {
	final mime:String;
	final data:tink.Chunk;
	var ?dataUrl:String;
}