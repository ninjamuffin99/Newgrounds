package io.newgrounds.objects;

@:noCompletion
typedef RawErrorData = {
	
	var message(default, never):String;
	var code   (default, never):Null<Int>;
}

@:forward
abstract Error(RawErrorData) from RawErrorData {
	
	inline public function new(message:String, ?code:Int)
	{
		this = { message:message, code:code };
	}
	
	inline public function toString():String {
		
		return (this.code != null ? '#${this.code} - ' : "") + this.message;
	}
}
