package movienight.view.leaderboard
{
	import fonts.PlutoSansLight;
	import fonts.PlutoSansMedium;
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.enum.Strings;
	import movienight.model.vo.LeaderboardEntryVO;
	import movienight.util.Factory;
	import movienight.view.core.ScreenView;
	import movienight.view.leaderboard.component.LeaderboardEntryRenderer;
	import movienight.view.ui.components.SignalButton;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	
	public class LeaderboardScreen extends ScreenView
	{
		
		public var signalPlayAgain : Signal = new Signal();
		
		private var _entries : Vector.<LeaderboardEntryVO>;
		private var _renderers : Vector.<LeaderboardEntryRenderer>;
		private var _titleBackground : Quad;
		private var _titleText : TextField;
		private var _playerMsgText : TextField;
		private var _playerScoreText : TextField;
		private var _ptsText : TextField;
		
		private var _playAgainButton : SignalButton;
		
		////////////////////////////////////////////////////////////////
		
		public function build( leaderboardEntries : Vector.<LeaderboardEntryVO>, userEntry : LeaderboardEntryVO ):void
		{
			
			_entries = leaderboardEntries;
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_titleBackground = new Quad( Constants.APP_WIDTH, 82, 0x333333, true );
			
			_titleText = new TextField( Constants.APP_WIDTH, 82, "LEADERBOARD", new PlutoSansRegular().fontName, 40, 0xFFFFFF );
			_titleText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_titleText.x = ( Constants.APP_WIDTH - _titleText.width ) >> 1;
			_titleText.y = ( _titleBackground.height - _titleText.height ) >> 1;
			
			_playerMsgText = new TextField( Constants.APP_WIDTH, 82, userEntry.player.toUpperCase() + "\nYOU SCORED", new PlutoSansRegular().fontName, 30, 0xFFFFFF );
			_playerMsgText.hAlign = HAlign.CENTER;
			_playerMsgText.autoSize = TextFieldAutoSize.VERTICAL;
			_playerMsgText.x = ( Constants.APP_WIDTH - _playerMsgText.width ) >> 1;
			_playerMsgText.y = 134;
			
			_playerScoreText = new TextField( Constants.APP_WIDTH, 82, userEntry.score.toString(), new PlutoSansMedium().fontName, 60, 0xFFFFFF );
			_playerScoreText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_playerScoreText.x = ( Constants.APP_WIDTH - _playerScoreText.width ) >> 1;
			_playerScoreText.y = 205;
			
			_ptsText = new TextField( 10, 10, "pts", new PlutoSansRegular().fontName, 32, 0xFFFFFF );
			_ptsText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_ptsText.x = _playerScoreText.x + _playerScoreText.width;
			_ptsText.y = _playerScoreText.y + _playerScoreText.height - _ptsText.height - 10;
			
			_playerScoreText.x -= _ptsText.width * 0.5; 
			_ptsText.x -= _ptsText.width * 0.5;
			
			_renderers = new Vector.<LeaderboardEntryRenderer>();
			var renderer : LeaderboardEntryRenderer;
			var ypos : int = 315;
			var userEntryInserted : Boolean;
			for( var i : int; i < _entries.length; i++ )
			{
				if( !userEntryInserted && userEntry.score > _entries[i].score )
				{
					_entries.splice( i, 0, userEntry );
					_entries.pop();
					userEntryInserted = true;
				}
				renderer = new LeaderboardEntryRenderer( _entries[i], i + 1 );
				renderer.x = ( Constants.APP_WIDTH - renderer.width ) >> 1;
				renderer.y = ypos;
				ypos += 95;
				addChild( renderer );
				_renderers.push( renderer );
			}
			
			_playAgainButton = Factory.createDefaultButton( Strings.PLAY_AGAIN, "icon_refresh", new PlutoSansLight().fontName, 25, 0x333333 );
			_playAgainButton.x = ( Constants.APP_WIDTH - _playAgainButton.width ) >> 1;
			_playAgainButton.y = 840;
			_playAgainButton.signalTriggered.add( onPlayAgain );
			
			addChild( _titleBackground );
			addChild( _titleText );
			addChild( _playerMsgText );
			addChild( _playerScoreText );
			addChild( _ptsText );
			addChild( _playAgainButton );
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			var signalShowComplete : Signal = new Signal();
			
			_titleBackground.y = -_titleBackground.height;
			Starling.juggler.tween( _titleBackground, 0.4, { delay : 0.0, y : 0, transition : Transitions.EASE_IN_OUT } );
			
			_titleText.alpha = 0;
			Starling.juggler.tween( _titleText, 0.4, { delay : 0.4, alpha : 1 } );
			
			_playerMsgText.alpha = 0;
			Starling.juggler.tween( _playerMsgText, 0.4, { delay : 0.4, alpha : 1 } );
			
			_playerScoreText.alpha = 0;
			Starling.juggler.tween( _playerScoreText, 0.4, { delay : 0.5, alpha : 1 } );
			
			_ptsText.alpha = 0;
			Starling.juggler.tween( _ptsText, 0.4, { delay : 0.5, alpha : 1 } );

			var targetY : int;
			for( var  i : int; i < _renderers.length; i++ )
			{
				targetY = _renderers[i].y;
				_renderers[i].y += 100;
				_renderers[i].alpha = 0;
				Starling.juggler.tween( _renderers[i], 0.4, { delay : 0.5 + ( i * 0.1 ), alpha : 1, y : targetY, transition : Transitions.EASE_IN_OUT } );
			}
			
			_playAgainButton.alpha = 0;
			_playAgainButton.y = 920;
			Starling.juggler.tween( _playAgainButton, 0.4, { delay : 1.0, y : 820, alpha : 1, transition : Transitions.EASE_IN_OUT, onComplete : signalShowComplete.dispatch } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			Starling.juggler.tween( _playAgainButton, 0.4, { y : 920, alpha : 0, transition : Transitions.EASE_IN_OUT } );
			
			for( var  i : int = 1; i <= _renderers.length; i++ )
			{
				Starling.juggler.tween( _renderers[_renderers.length - i], 0.4, { delay : i * 0.1, alpha : 0 } );
			}
			
			Starling.juggler.tween( _playerMsgText, 0.4, { delay : 0.4, alpha : 0 } );
			Starling.juggler.tween( _playerScoreText, 0.4, { delay : 0.5, alpha : 0 } );
			Starling.juggler.tween( _ptsText, 0.4, { delay : 0.5, alpha : 0 } );
			Starling.juggler.tween( _titleText, 0.4, { delay : 0.6, alpha : 0 } );
			Starling.juggler.tween( _titleBackground, 0.4, { delay : 0.9, y : -_titleBackground.height, transition : Transitions.EASE_IN_OUT, onComplete : signalHideComplete.dispatch } );
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onPlayAgain( target : SignalButton ) : void 
		{
			_playAgainButton.enabled = false;
			signalPlayAgain.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose():void
		{
			signalPlayAgain.removeAll();
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}