package movienight.view.categoryselect.component
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import movienight.enum.Constants;
	import movienight.model.vo.CategoryVO;
	import movienight.util.Utils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class CategorySelectComponent extends Sprite
	{
		
		private const DEG_TO_RAD : Number = Math.PI / 180;
		private const RESOLUTION : int = 360;
		
		private var _categories : Vector.<CategoryVO>;
		
		private var _outerRadius : int = 210;
		private var _sliceRadius : int = 193;
		
		private var _categoryWheel : Image;
		private var _increment : Number = ( 360 / RESOLUTION );
		
		////////////////////////////////////////////////////////////////
		
		public function get segmentAngle() : Number 
		{
			return 360 / _categories.length;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function CategorySelectComponent( categories : Vector.<CategoryVO> )
		{
			_categories = categories;
									
			_categoryWheel = new Image( drawCategoryTexture() );
			Utils.centerPivot( _categoryWheel );
			_categoryWheel.rotation = -deg2rad( 90 + segmentAngle * 0.5 );
			_categoryWheel.touchable = false;
			addChildAt( _categoryWheel,0 );
			
			flatten();
			
		}
		
		////////////////////////////////////////////////////////////////
		
		private function drawCategoryTexture() : Texture
		{
			var categoryAngleIncrement : Number = segmentAngle;
			var i : int,
			categoryIndex : int,
			angle : Number = 0,
			angleDif : Number = 0,
			categoryAngle : Number = 0,
			xpos : Number = 0,
			ypos : Number = 0,
			isNextSlice : Boolean;
			
			var commands : Vector.<int> = new Vector.<int>();
			var pathData : Vector.<Number> = new Vector.<Number>();

			var shape : Shape = new Shape();
			shape.graphics.beginFill( 0, 0.3 );
			shape.graphics.drawCircle( 0, 0, _outerRadius );
			shape.graphics.endFill();
			
			var color : uint = categoryIndex < Constants.CATEGORY_COLORS.length ? Constants.CATEGORY_COLORS[ categoryIndex ] : Math.random() * 0xFFFFFF;
			shape.graphics.beginFill( color );
			
			commands.push( 1 );
			pathData.push( xpos = Math.cos( 0 ) * _sliceRadius );
			pathData.push( ypos = Math.sin( 0 ) * _sliceRadius );
			
			for( i = 0; i < RESOLUTION; i++ )
			{
				if( categoryIndex < _categories.length )
				{
					categoryAngle = categoryIndex * categoryAngleIncrement;
					if( angle + _increment > categoryAngle )
					{
						isNextSlice = true;
						angleDif = (angle + _increment) - ( categoryAngle );
						angle = categoryAngle;
						categoryIndex ++;
					}
					else {
						angle += _increment;
					}
				} else {
					angle += _increment;
				}
				
				commands.push( 2 );
				xpos = Math.cos( angle * DEG_TO_RAD ) * _sliceRadius;
				ypos = Math.sin( angle * DEG_TO_RAD ) * _sliceRadius;
				pathData.push( xpos );
				pathData.push( ypos );
				
				if( isNextSlice )
				{
					commands.push( 2 );
					pathData.push( 0 );
					pathData.push( 0 );
					
					shape.graphics.drawPath( commands, pathData );
					shape.graphics.endFill();
					
					commands = new Vector.<int>();
					pathData = new Vector.<Number>();
					
					commands.push( 2 );
					pathData.push( xpos );
					pathData.push( ypos );
					
					shape.graphics.beginFill( color );
					angle += angleDif;
					isNextSlice = false;
					
					color = categoryIndex < Constants.CATEGORY_COLORS.length ? Constants.CATEGORY_COLORS[ categoryIndex ] : Math.random() * 0xFFFFFF;
				}
			}
			
			shape.graphics.drawPath( commands, pathData );
			shape.graphics.endFill();
			
			var bmd : BitmapData = new BitmapData( _outerRadius * 2, _outerRadius * 2, true, 0xCCCCCC );
			bmd.draw( shape, new Matrix( 1,0,0,1,_outerRadius,_outerRadius ), null, null, null, true );
			
			var texture : Texture = Texture.fromBitmapData( bmd );
			bmd.dispose();
			
			return texture;
			
		}
		
		////////////////////////////////////////////////////////////////
	}
}