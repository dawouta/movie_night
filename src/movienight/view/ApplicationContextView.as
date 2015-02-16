package movienight.view
{
	
	import movienight.enum.Constants;
	import movienight.enum.Screens;
	import movienight.util.Tracer;
	import movienight.view.apploader.ApplicationLoaderScreen;
	import movienight.view.camera.CameraScreen;
	import movienight.view.categoryselect.CategorySelectScreen;
	import movienight.view.core.ScreenPresenter;
	import movienight.view.game.GameScreen;
	import movienight.view.leaderboard.LeaderboardScreen;
	import movienight.view.roundcomplete.RoundCompleteScreen;
	import movienight.view.start.StartScreen;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ApplicationContextView extends Sprite
	{
		
		private var _screenPresenter : ScreenPresenter;
		
		////////////////////////////////////////////////////////////////
		
		public function init() : void
		{
			Tracer.out();
			addBackground();
			addScreenPresenter();
		}

		////////////////////////////////////////////////////////////////
		
		public function showScreen( screenName : String ) : void 
		{
			_screenPresenter.showScreen( screenName );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function addBackground() : void 
		{
			var bg:Image =  new Image( Assets.getTexture("BackgroundTexture") );
			bg.height = Constants.APP_HEIGHT;
			bg.x = ( Constants.APP_WIDTH - bg.width ) >> 1;
			addChild(bg);
		}
		
		////////////////////////////////////////////////////////////////
		
		private function addScreenPresenter() : void 
		{
			_screenPresenter = new ScreenPresenter();
			addChild(_screenPresenter );
			
			_screenPresenter.addScreen( Screens.APPLICATION_LOADER_SCREEN, ApplicationLoaderScreen );	
			_screenPresenter.addScreen( Screens.START_SCREEN, StartScreen );
			_screenPresenter.addScreen( Screens.CAMERA_SCREEN, CameraScreen );
			_screenPresenter.addScreen( Screens.CATEGORY_SELECT_SCREEN, CategorySelectScreen );
			_screenPresenter.addScreen( Screens.GAME_SCREEN, GameScreen );
			_screenPresenter.addScreen( Screens.ROUND_COMPLETE, RoundCompleteScreen );
			_screenPresenter.addScreen( Screens.LEADERBOARD_SCREEN, LeaderboardScreen );

		}
		
		////////////////////////////////////////////////////////////////
		
	}
}