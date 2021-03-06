/**
 * ---------------------------------------------------------------------------
 *   Copyright (C) 2008 0x6e6562
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 * ---------------------------------------------------------------------------
 **/
package com.squarespace.hopper.json.mock
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.EventDispatcher;
	
	import org.amqp.patterns.CorrelatedMessageEvent;
	import org.amqp.patterns.RpcClient;
	import org.amqp.util.Guid;

	public class MockClient implements RpcClient
	{
		
		private var server:MockServer;
		private var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function MockClient(s:MockServer) {
			server = s;
		}
		
		public function send(o:*, callback:Function):void
		{
			var guid:String = Guid.next();
			o.correlationId = guid;
			dispatcher.addEventListener(guid,callback);
			var encoded:String = JSON.encode(o);
			var decoded:* = JSON.decode(encoded);
			var result:* = server.process(decoded);
			
			var resultEncoded = JSON.encode(result);
			var resultDecoded = JSON.decode(resultEncoded);
			
			dispatcher.dispatchEvent(new CorrelatedMessageEvent(guid, resultDecoded));	
		}
		
	}
}