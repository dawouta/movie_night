package movienight.view.game.component
{
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.model.vo.ResultVO;
	import movienight.util.Utils;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class GameRoundRenderer extends Sprite
	{
		
		private var _results : Vector.<ResultVO>;
		private var _bg : Quad;
		private var _currentScoreText : TextField;
		private var _currentScoreTitle : TextField;
		private var _ptsLabel : TextField;
		private var _resultIcons : Vector.<Image>;
		
		////////////////////////////////////////////////////////////////
		
		public function GameRoundRenderer( results : Vector.<ResultVO> )
		{
			_results = results;
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_bg = new Quad( Constants.APP_WIDTH, 95, 0x333333, true );
			addChild( _bg )
			
			_resultIcons = new Vector.<Image>();
			var icon : Image;
			var texPrefix : String = "round_result_icon_round_";
			var texId : String;
			var xpos : int = 260;
			var currentScore : int = 0;
			for( var i : int; i < _results.length; i++ )
			{
				texId = _results[i].wasCorrect ? texPrefix + "correct" : texPrefix + "incorrect"
				icon = new Image( atlas.getTexture( texId ) );
				icon.x = xpos;
				Utils.centerPivot( icon );
				icon.y = _bg.height >> 1;
				xpos += 60;
				addChild( icon )
				_resultIcons.push( icon );
				currentScore += _results[i].score;
			}
			
			while( _resultIcons.length < 5 )
			{
				texId = texPrefix + ( _resultIcons.length + 1 );
				icon = new Image( atlas.getTexture( texId ) );
				icon.x = xpos;
				Utils.centerPivot( icon );
				icon.y = _bg.height >> 1;
				xpos += 60;
				addChild( icon )
				_resultIcons.push( icon );
			}
			
			_currentScoreTitle = new TextField( 175, 20, "SCORE", new PlutoSansRegular().fontName, 18, 0xFFFFFF );
			_currentScoreTitle.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_currentScoreTitle.x = 32;
			_currentScoreTitle.y = 10;
			addChild( _currentScoreTitle );
			
			_currentScoreText = new TextField( 175, 40, Utils.addLeadingZeros(currentScore,5), new PlutoSansRegular().fontName, 36, 0xFFFFFF );
			_currentScoreText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_currentScoreText.x = 32;
			_currentScoreText.y = 30;
			addChild( _currentScoreText );
			
			_ptsLabel = new TextField( 175, 40, "pts", new PlutoSansRegular().fontName, 14, 0xFFFFFF );
			_ptsLabel.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_ptsLabel.x = _currentScoreText.x + _currentScoreText.width;
			_ptsLabel.y = 52;
			addChild( _ptsLabel );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		public function show( delay : Number = 0 ) : Number 
		{
			
			_bg.y = _bg.height;
			Starling.juggler.tween( _bg, 0.3, { delay : delay, y : 0, transition : Transitions.EASE_IN_OUT } );
			delay += 0.3;
			
			_currentScoreTitle.alpha = 0;
			Starling.juggler.tween( _currentScoreTitle, 0.3, { delay : delay, alpha : 1 } );
			
			_currentScoreText.alpha = 0;
			Starling.juggler.tween( _currentScoreText, 0.3, { delay : delay + 0.1, alpha : 1 } );
			
			_ptsLabel.alpha = 0;
			Starling.juggler.tween( _ptsLabel, 0.3, { delay : delay + 0.2, alpha : 1 } );
			
			var icon : Image;
			for( var i : int; i < _resultIcons.length; i++ )
			{
				icon = _resultIcons[i];
				icon.alpha = 0;
				icon.scaleX = icon.scaleY = 0;
				Starling.juggler.tween( icon, 0.3, { delay : delay, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_IN_OUT } );
				delay += 0.1;
			}
			
			return delay;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function hide( delay : Number = 0 ) : Number 
		{
			var icon : Image;
			for( var i : int; i < _resultIcons.length; i++ )
			{
				icon = _resultIcons[i];
				Starling.juggler.tween( icon, 0.3, { delay : delay, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_OUT } );
				delay += 0.1;
			}
			Starling.juggler.tween( _currentScoreTitle, 0.3, { delay : delay, alpha : 0 } );
			Starling.juggler.tween( _currentScoreText, 0.3, { delay : delay, alpha : 0 } );
			Starling.juggler.tween( _ptsLabel, 0.3, { delay : delay, alpha : 0 } );
			
			Starling.juggler.tween( _bg, 0.3, { delay : delay + 0.3, y : _bg.height, transition : Transitions.EASE_IN_OUT } );
			
			return delay + 0.6;
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			_resultIcons = null;
			_results = null;
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}