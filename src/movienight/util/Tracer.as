/**
 * Copyright (c) 2009 Rigard Kruger
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

package movienight.util
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Rigard Kruger
	 */
	public class Tracer 
	{
		
		public static var isPC:Boolean = false;
		
		private static var _isDebugging:Boolean = true;
		private static var _useTimeStamp:Boolean;
		private static var _stage:Stage;
		private static var _showFunctions:Boolean;
		
		private static var _keyarr:Array = [];
		private static var _currentclassref:String;
		private static var _lineLength:int = 60;
		private static var _stackOffset:int = 0;
		private static var _suppressInfo:Boolean = false;
		
		/**
		 * Initialises the Tracer class.
		 * 
		 * @param	isDebugging 	Sets whether we are in debug mode. If true, traces will be displayed.
		 * @param	useTimeStamp 	Determines whether a timestamp should be added to the trace.
		 * @param	stage 			If stage is specified, the user will have the option of 
		 * 							toggling the debug mode by typing in the letters of the word "debug".
		 * @param	showFunctions	If true, the function that contains the trace will be listed.
		 */
		public static function init(isDebugging:Boolean, useTimeStamp:Boolean = false, stage:Stage = null, showFunctions:Boolean = false):void
		{
			_isDebugging = isDebugging;
			_useTimeStamp = useTimeStamp;
			_stage = stage;
			_showFunctions = showFunctions;
			if (_stage)
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			_lineLength = 60; //reset length on init
		}
		
		/**
		 * Traces out the arguments with their originating class and line number. 
		 * 
		 * The class will generate an error and extract the originating source code line 
		 * from the error's stack trace in order to display this. If useTimeStamp is specified, it will
		 * include the time of the trace.
		 * 
		 * @param	...args
		 */
		public static function out(...args) : void
		{
			
			//Debug.log(args.join(' '));
			if (!_isDebugging) return;
			
			//throw new Error();
			
			var e:Error = new Error();
			try
			{
				
				var errorSourceLine:String = String((e.getStackTrace().split("\n") as Array)[2 + _stackOffset]);
				var sourceLocation:String;
				var classRef:String;
				var functionRef:String;
				
				if (Capabilities.os.indexOf("Windows") != -1)
					isPC = true;
				
				var dirSplitter:String = isPC ? "\\" : "\/";
				
				sourceLocation = String(errorSourceLine.split(":").pop().slice(0, -1));
				classRef = String(errorSourceLine.split(dirSplitter).pop().split(":").shift());
				var classRefNoExt:String = classRef.substr(0, classRef.indexOf("."));
				var functionStartId:int = errorSourceLine.indexOf(classRefNoExt);
				functionRef = errorSourceLine.substring(functionStartId + classRefNoExt.length + 1, errorSourceLine.indexOf("("));
				if(functionRef == "(") //constructor
					functionRef = "*";
				if (classRef != _currentclassref)
					trace("");
					
				_currentclassref = classRef;
				
				var timeStamp:String = "";
				if (_useTimeStamp)
				{
					var d:Date = new Date();
					timeStamp = ", " + formatNumber(d.hours, 3) + ":" + formatNumber(d.minutes, 10) + ":" + formatNumber(d.seconds, 10) + ":" + formatNumber(d.milliseconds, 100);
				}
				
				classRef += "[" + functionRef + "]:" + sourceLocation + timeStamp;
				
				var padding:String = "";
				_lineLength = Math.max(classRef.length + 4, _lineLength);
				for(var i:int = 0; i < _lineLength; i++)
					padding += " ";
				
				trace((_suppressInfo? padding: classRef + padding.slice(classRef.length)) + args.join(' '));
			}
			catch (e:Error)
			{
				trace(args);
			}
		}
		
		/**
		 * console.log using ExternalInterface
		 * @param	value
		 */
		public static function log(...args):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("console.log", args);
			}
			else
			{
				//_stackOffset = 1;
				//_suppressInfo = true;
				out.apply(Tracer, args);// ("[external] " + value);
				//_suppressInfo = false;
				//_stackOffset = 0;
			}
		}
		public static function outObject(obj:Object, lead:String = ""):void
		{
			var padding:String = "";
			for(var i:int = 0; i < _lineLength; i++)
				padding += " ";
			_stackOffset = 1;
			out(lead);
			_suppressInfo = true;
			out(parseObject(obj, padding));
			_suppressInfo = false;
			_stackOffset = 0;
		}
		
		private static function parseObject(obj:Object, padding:String = ""):String
		{
			var str:String = "";
			for(var prop:String in obj)
			{
				//str += "*" + obj[prop] is Object;
				if(obj[prop] is Array || getQualifiedClassName(obj[prop]) == "Object")
					str += padding + "> " + prop + ": \n" + parseObject(obj[prop], padding + "  ");
				else
					str += padding + "> " + prop + ": " + obj[prop] + "\n";
			}
			return str;
		}
		
		/**
		 * Formats and returns the number by prepending it with zeroes depending on the magnitude specified
		 * 
		 * @param	number 		The number to format
		 * @param	magnitude 	The magnitude. Should be in orders of magnitude of 10.
		 * @return	The formatted number
		 */
		private static function formatNumber(number:Number, magnitude:int):String
		{
			var str:String = number.toString();
			while (magnitude > 1)
			{
				if (number < magnitude)
					str = "0" + str;
					
				magnitude *= 0.1;
			}
			
			return str;
		}
		
		/**
		 * Handles key down events. If the user presses the letters of the word "debug",
		 * the Tracer will toggle its debug state between true and false. Useful if deploying
		 * a debug version of the flash file to a live server by setting the initial debug
		 * state to false, thus not allowing tools like Flash Tracer to output any trace
		 * messages, unless the developer types required keys.
		 * 
		 * @param	e
		 */
		private static function handleKeyDown(e:KeyboardEvent) : void
		{
			
			// d = 68
			// e = 69
			// b = 66
			// u = 85
			// g = 71
			
			var keyCode:int = e.keyCode;
			
			switch (keyCode)
			{
				case 68:
				case 69:
				case 66:
				case 85:
				case 71:
					_keyarr.push(keyCode);
					if (_keyarr.length > 5)
						_keyarr.shift();
					
					if (_keyarr[0] == 68 &&
						_keyarr[1] == 69 &&
						_keyarr[2] == 66 &&
						_keyarr[3] == 85 &&
						_keyarr[4] == 71)
					{
						_isDebugging = !_isDebugging;
						
						trace("-------- Debug mode: " + _isDebugging + " --------");
					}
					break;
				
				default:
					_keyarr = [];
					break;
			}
			
		}
		
	}
	
}