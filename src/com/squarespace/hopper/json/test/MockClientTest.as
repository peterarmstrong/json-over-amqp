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
package com.squarespace.hopper.json.test
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.amqp.patterns.CorrelatedMessageEvent;
	import org.amqp.patterns.RpcClient;
	import org.pranaframework.context.support.XMLApplicationContext;

	public class MockClientTest extends TestCase
	{
		protected static const TIMEOUT:int = 5000;
		
		private var ctx:XMLApplicationContext;
		
		public static function suite(ctx:XMLApplicationContext):TestSuite {
            var myTS:TestSuite = new TestSuite();
            myTS.addTest(new MockClientTest(ctx,"testClient"));
            return myTS;
        }
		
		public function MockClientTest(c:XMLApplicationContext, methodName:String=null)
		{
			super(methodName);
			this.ctx = c;
		}
		
		public function testClient():void {
			var client:RpcClient = ctx.getObject("client") as RpcClient;			
			var testObject:* = new Object();
			testObject.first = 	"foo";
			testObject.second = "bar";
			client.send(testObject, addAsync(onResult, TIMEOUT) );			
		}
		
		public function onResult(event:CorrelatedMessageEvent):void {
			trace("finished");
			assertEquals("foobar",event.result);
		}
		
	}
}