package io.newgrounds.objects.events;

import haxe.Json;
import io.newgrounds.objects.Error;
import io.newgrounds.objects.events.Result;

typedef DebugResponse = {
	
	var exec_time:Int;
	var input:Dynamic;
}

@:noCompletion
typedef RawResponse<T:ResultBase> = {
	
	var success(default, null):Bool;
	var error  (default, null):Null<Error>;
	var debug  (default, null):Null<DebugResponse>;
	var result (default, null):Null<Result<T>>;
	var app_id (default, null):String;
}

@:forward(
	success,
	error,
	debug,
	result
) abstract Response<T:ResultBase>(RawResponse<T>) {
	
	public var appId(get, never):String; inline function get_appId() return this.app_id;
	
	public function new (core:NGLite, reply:String) {
		
		try { this = Json.parse(reply); }
		catch (e:Dynamic) {
			
			this = Json.parse('{"success":false,"error":{"message":"Error parsing reply:\'$reply\' error:\'$e\'","code":0}}');
		}
		
		if (!this.success)
			core.logError('Call unseccessful: ${this.error}');
		else if(!this.result.success)
			core.logError('${this.result.component} fail: ${this.result.error}');
	}
}
