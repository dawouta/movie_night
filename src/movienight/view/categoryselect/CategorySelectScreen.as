package movienight.view.categoryselect
{
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.enum.Strings;
	import movienight.model.vo.CategoryVO;
	import movienight.util.Utils;
	import movienight.view.categoryselect.component.CategorySelectComponent;
	import movienight.view.core.ScreenView;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	
	public class CategorySelectScreen extends ScreenView
	{
		
		public var signalCommenceSpin : Signal = new Signal();
		public var signalCategorySelected : Signal = new Signal( int );
		
		private var _categories : Vector.<CategoryVO>;
		private var _logo : Image;
		private var _categorySelectComponent : CategorySelectComponent;
		private var _categoryWheelCenter : Image;
		private var _categoryWheelPrompt : TextField;
		private var _currentCategoryText : TextField;
		private var _categoryWheelArrowIndicator : Image;
		private var _roundLabelBackground : Quad;
		private var _roundLabelText : TextField;
		
		////////////////////////////////////////////////////////////////
		
		public function build( categories : Vector.<CategoryVO>, roundIndex : int ):void
		{
			_categories = categories;
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_roundLabelBackground = new Quad( Constants.APP_WIDTH, 82, 0x333333, true );
			
			var roundStr : String =  Strings.ROUND_OUT_OF;
			roundStr = roundStr.replace( "$current_round", roundIndex.toString() );
			roundStr = roundStr.replace( "$total_rounds", Constants.NUM_ROUNDS );
			_roundLabelText = new TextField( Constants.APP_WIDTH, 82, roundStr, new PlutoSansRegular().fontName, 40, 0xFFFFFF );
			_roundLabelText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_roundLabelText.x = ( Constants.APP_WIDTH - _roundLabelText.width ) >> 1;
			_roundLabelText.y = ( _roundLabelBackground.height - _roundLabelText.height ) >> 1;
			
			_logo = new Image( atlas.getTexture( "logo_large" ) );
			Utils.centerPivot( _logo );
			_logo.x = Constants.APP_WIDTH >> 1;
			_logo.y = 250;
			
			_categorySelectComponent = new CategorySelectComponent( _categories );
			_categorySelectComponent.x = Constants.APP_WIDTH >> 1;
			_categorySelectComponent.y = 688;
			
			_categoryWheelCenter = new Image( atlas.getTexture("category_wheel_center") );
			Utils.centerPivot( _categoryWheelCenter );
			_categoryWheelCenter.x = _categorySelectComponent.x;
			_categoryWheelCenter.y = _categorySelectComponent.y;
			
			_categoryWheelArrowIndicator = new Image( atlas.getTexture("category_wheel_indicator_arrow") );
			_categoryWheelArrowIndicator.x = ( Constants.APP_WIDTH - _categoryWheelArrowIndicator.width ) >> 1;
			_categoryWheelArrowIndicator.y = 455;
			
			_categoryWheelPrompt = new TextField( _categoryWheelCenter.width - 10, 82, Strings.TAP_TO_SELECT_CATEGORY, new PlutoSansRegular().fontName, 20, 0x333333 );
			_categoryWheelPrompt.autoSize = TextFieldAutoSize.VERTICAL;
			_categoryWheelPrompt.hAlign = HAlign.CENTER;
			_categoryWheelPrompt.x = ( Constants.APP_WIDTH - _categoryWheelPrompt.width ) >> 1;
			_categoryWheelPrompt.y = 688 - ( _categoryWheelPrompt.height >> 1 );
			_categoryWheelPrompt.touchable = false;
			
			_currentCategoryText = new TextField( _categoryWheelCenter.width - 10, 82, _categories[0].name.toUpperCase(), new PlutoSansRegular().fontName, 32, 0x333333 );
			_currentCategoryText.hAlign = HAlign.CENTER;
			_currentCategoryText.x = ( Constants.APP_WIDTH - _currentCategoryText.width ) >> 1;
			_currentCategoryText.y = 688 - ( _currentCategoryText.height >> 1 );
			_currentCategoryText.touchable = false;
			_currentCategoryText.visible = false;
			
			addChild( _logo );
			addChild( _roundLabelBackground );
			addChild( _roundLabelText );
			addChild( _categorySelectComponent );
			addChild( _categoryWheelCenter );
			addChild( _categoryWheelPrompt );
			addChild( _currentCategoryText );
			addChild( _categoryWheelArrowIndicator );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			var signalShowComplete : Signal = new Signal();
			
			_logo.alpha = 0;
			_logo.scaleX = _logo.scaleY = 0;
			Starling.juggler.tween( _logo, 0.6, { delay : 0.0, alpha : 1, scaleX : 0.7, scaleY : 0.7, transition : Transitions.EASE_OUT_BACK } );

			_categoryWheelCenter.alpha = 0;
			_categoryWheelCenter.scaleX = _categoryWheelCenter.scaleY = 0;
			Starling.juggler.tween( _categoryWheelCenter, 0.4, { delay : 0.2, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_IN_OUT } );
			
			_categorySelectComponent.alpha = 0;
			_categorySelectComponent.scaleX = _categorySelectComponent.scaleY = 0.6;
			Starling.juggler.tween( _categorySelectComponent, 1.2, { delay : 0.4, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_ELASTIC } );
			
			_categoryWheelArrowIndicator.alpha = 0;
			_categoryWheelArrowIndicator.y = 400;
			Starling.juggler.tween( _categoryWheelArrowIndicator, 1.0, { delay : 0.6, alpha : 1, y : 455, transition : Transitions.EASE_OUT_BACK } );
			
			_categoryWheelPrompt.alpha = 0;
			Starling.juggler.tween( _categoryWheelPrompt, 0.4, { delay : 0.6, alpha : 1, transition : Transitions.EASE_OUT_BACK } );
			
			_roundLabelBackground.y = -_roundLabelBackground.height;
			Starling.juggler.tween( _roundLabelBackground, 0.4, { delay : 0.6, y : 0, transition : Transitions.EASE_IN_OUT } );
			
			_roundLabelText.alpha = 0;
			Starling.juggler.tween( _roundLabelText, 0.4, { delay : 0.8, alpha : 1, onComplete : onShowComplete, onCompleteArgs : [ signalShowComplete ] } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete( signalShowComplete : Signal ) : void 
		{
			signalShowComplete.dispatch();
			_categoryWheelCenter.addEventListener( TouchEvent.TOUCH, onTouch );
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			Starling.juggler.tween( _roundLabelText, 0.4, { delay : 0.0, alpha : 0 } );
			Starling.juggler.tween( _roundLabelBackground, 0.4, { delay : 0.4, y : -_roundLabelBackground.height, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _currentCategoryText, 0.3, { delay : 0, alpha : 0 } );
			Starling.juggler.tween( _categoryWheelArrowIndicator, 0.3, { delay : 0.1, alpha : 0, y : 400, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _categorySelectComponent, 0.6, { delay : 0.3, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK } );
			Starling.juggler.tween( _categoryWheelCenter, 0.6, { delay : 0.4, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK } );
			Starling.juggler.tween( _logo, 0.4, { delay : 0.6, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK } );
			Starling.juggler.delayCall( signalHideComplete.dispatch, 1.2 );
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onTouch( event : TouchEvent ):void
		{
			var t : Touch = event.getTouch( this, TouchPhase.ENDED );
			if( !t ) return;
			AudioAssets.play( AudioAssets.SOUND_CLICK );
			_categoryWheelCenter.removeEventListener( TouchEvent.TOUCH, onTouch );
			_categoryWheelPrompt.visible = false;
			signalCommenceSpin.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		public function startSpin( categoryIndex : int ) : void 
		{
			_currentCategoryText.visible = true;
			
			var categoryIncrement : Number = _categorySelectComponent.segmentAngle;
			var offsetRotation : Number = categoryIncrement * categoryIndex;
			var targetRotation : Number = deg2rad( 1800 + offsetRotation + 0.1 );
			var currentIndex : int;
			var currentRotation : Number = 0;
			
			Starling.juggler.tween( _categorySelectComponent, 5, { rotation : targetRotation, transition : Transitions.EASE_IN_OUT,
				onUpdate : function() : void 
				{
					currentRotation = rad2deg( _categorySelectComponent.rotation ) % 360 + ( categoryIncrement * 0.5 );
					if( currentRotation < 0 ) currentRotation += 360;
					currentIndex = Math.floor( currentRotation / categoryIncrement );
					if( _currentCategoryText.text !== _categories[ currentIndex ].name.toUpperCase() ) 
					{
						AudioAssets.play( AudioAssets.SOUND_CATEGORY_WHEEL_TICK );
						_currentCategoryText.text = _categories[ currentIndex ].name.toUpperCase();
					}
				},
				onComplete : function():void
				{
					Starling.juggler.delayCall( signalCategorySelected.dispatch, 0.4, categoryIndex );
				}
			} );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose():void
		{
			_categoryWheelCenter.removeEventListener( TouchEvent.TOUCH, onTouch );
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}