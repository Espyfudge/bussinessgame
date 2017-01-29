package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.display.Stage;
import openfl.Lib;
import openfl.events.Event;

import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.display.Tilemap;

import openfl.geom.Rectangle;
import openfl.geom.Point;


class SecondEnemy extends Sprite
{
	
	var lastUpdate : Int;
	
	var gravity : Float = 0.9;
	var velocity : Point = new Point( 0, 0 );
	var isOnGround : Bool;
	
	var enemyHealth : Int = 100;
	var enemyDamage : Int = 35;
	
	var tileSet : Tileset;
	
	public var secondEnemy : Tilemap;
	
	static inline var fps : Int = 6;
	var msPerFrame : Int = Std.int( 1000 / fps );
	static inline var frameCount : Int = 22;
	
	var currentDuration : Int = 0;
	var currentFrame : Int = 1;
	
	var rollLeftSequence : Array<Int> = [0, 1, 2, 3];
	var rollRightSequence : Array<Int> = [18, 19, 20, 21];
	
	//dying sequence: can u look if it's fine?
	var dyingLeftSequence : Array<Int> = [4, 5, 6, 7, 8, 9, 10];
	var dyingRightSequence : Array<Int> = [17, 16, 15, 14, 13, 12, 11];
	
	var currentStateFrames : Array<Int>;
	
	var faces : Int = 0;

	var player : Player;

	var mainStage : Stage;

	var main : screens.GameScreen;
	

	public function new(st : screens.GameScreen, playerRef : Player, secondEnemyX : Int) 
	{
		super();
		
		player = playerRef;
		
		main = st;
		
		mainStage = st.stage;
		
		
		var bitmapData : BitmapData = Assets.getBitmapData( "assets/SecondEnemySheet.png" );
		tileSet = new Tileset( bitmapData );
		
		secondEnemy = new Tilemap( 256, 256, tileSet);
		
		initializeSpriteSheet();
		
		secondEnemy.addTile( new Tile( 0 ) );
		
		addChild( secondEnemy );
		secondEnemy.x = -secondEnemy.width / 2;
		
		this.x = secondEnemyX;
		
		currentStateFrames = rollRightSequence;
		
		this.addEventListener( Event.ENTER_FRAME, updates );
		this.addEventListener( Event.ENTER_FRAME, update );
		
		lastUpdate = Lib.getTimer();
		
		this.addEventListener(Event.ENTER_FRAME, everyFrame );
	}
	
	function initializeSpriteSheet() 
	{
		// frames are 344x344
		for ( i in 0 ... frameCount ) 
		{
			tileSet.addRect( new Rectangle ( i * 256, 0, 256, 256 ) );
		}
	}
	
	public function updates( deltaTime : Float ) 
	{
		currentDuration += Std.int( deltaTime * 1000 );
		
		if ( currentDuration > msPerFrame ) 
		{
			currentDuration -= msPerFrame;
			currentFrame++;
			
			if( currentFrame >= currentStateFrames.length )
			currentFrame = 1;
			
			secondEnemy.removeTile( secondEnemy.getTileAt( 0 ) );
			secondEnemy.addTile( new Tile( currentStateFrames[currentFrame] ) );
		}
	}
	
	function everyFrame( event : Event ) : Void 
	{
		// if the enemy is higher above ( less than ) do these still apply?
		if ( this.y < 670 ) 
		{
			// gravity applies, enemy isn't on ground do these still apply?
			velocity.y += gravity;
			isOnGround = false;
		}
		
		else 
		{
			velocity.y = 0;
			this.y = 670;
			isOnGround = true;
		}
		
		
		if ( this.x > 2100 ) 
		{
			velocity.x = -8;
			currentStateFrames = rollLeftSequence;
		}
		else if (this.x < -200 )
		{
			velocity.x = 8;
			currentStateFrames = rollRightSequence;
		}
		
		this.y += velocity.y;
		this.x += velocity.x;
	}
	
	function update ( event : Event ) 
	{
		var now : Int = Lib.getTimer();
		var deltaTime : Float = ( now - lastUpdate ) / 1000;
		lastUpdate = now;
		
		updates( deltaTime );
	}
	
	/*public function takeDamage ( damage : Int ) 
	{
		enemyHealth -= damage;
		
		//the dying animation here right?
		if ( enemyHealth <= 0 )
		{
			main.secondEnemy.remove( this );
			main.removeChild( this );
		}
	}*/
}