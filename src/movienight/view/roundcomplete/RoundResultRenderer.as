package movienight.view.roundcomplete
{
	import fonts.PlutoSansMedium;
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.util.Utils;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	
	public class RoundResultRenderer extends Sprite
	{
		
		private var _bg : Image;
		private var _titleText : TextField;
		private var _resultText : TextField;
		private var _counterObj : Object = { targetResult : 0 }
		
		////////////////////////////////////////////////////////////////
		
		public function RoundResultRenderer( title : String, bgTextureName : String )
		{
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_bg = new Image( atlas.getTexture( bgTextureName ) );
			_bg.x = -_bg.width >> 1;
			addChild( _bg );
			_bg.alpha = 0;
			
			_titleText = new TextField( _bg.width, 30, title, new PlutoSansRegular().fontName, 22, 0 );
			_titleText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_titleText.hAlign = HAlign.CENTER;
			_titleText.y = 18;
			_titleText.alpha = 0;
			Utils.centerPivot( _titleText );
			addChild( _titleText );
			
			_resultText = new TextField( _bg.width, 60, "", new PlutoSansMedium().fontName, 36, 0xFFFFFF );
			_resultText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_resultText.hAlign = HAlign.CENTER;
			_resultText.y = 42;
			_resultText.alpha = 0;
			addChild( _resultText );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		public function showResult( result : *, delay : Number, leadingZeroes : int = 0 ) : void 
		{
			var targetY : Number = this.y;
			this.y += 250;
			Starling.juggler.tween( this, 0.4, { delay : delay, y : targetY, alpha : 1, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _bg, 0.4, { delay : delay, alpha : 1 } );
			Starling.juggler.tween( _titleText, 0.4, { delay : delay + 0.4, alpha : 1 } );
			Starling.juggler.tween( _resultText, 0.4, { delay : delay + 0.4, alpha : 1 } );
			
			if( result is String )
			{
				_resultText.text = result;
				_resultText.x = -_resultText.width * 0.5;
			}
			else 
			{
				Starling.juggler.tween( _counterObj, 1, { delay : delay + 0.6, targetResult : result, onUpdate : resultUpdate, onUpdateArgs : [ leadingZeroes ] } );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		private function resultUpdate( leadingZeroes : int ) : void 
		{
//			_resultText.text = Utils.addLeadingZeros( _counterObj.targetResult, leadingZeroes );
			_resultText.text = Math.round(_counterObj.targetResult).toString();
			_resultText.x = -_resultText.width * 0.5;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function hide( delay : Number = 0 ) : Number 
		{
			return delay;
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}