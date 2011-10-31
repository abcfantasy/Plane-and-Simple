<<<<<<< HEAD
package
{
    import org.flixel.*;
 
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
    import Box2D.Common.*;
	import Box2D.Common.Math.*;
	
 
    public class B2FlxSprite extends FlxSprite
    {
		// The before-mentioned ratio of pixels/meter
        private var ratio:Number = 30;
		// The fixture is used by the body of the sprite, and contains physics parameters such as friction, restitution and density
        public var _fixDef:b2FixtureDef;
		// Initially, the body needs a bodyDef, that specifies initial position, angle and type. The idea is that multiple bodies can use the same bodyDef, and that the bodyDef remains untouched after declaration
        public var _bodyDef:b2BodyDef
        public var _obj:b2Body;
		// The anchor point is used to specify the position within the body, that the joint should connect to
		public var _anchor:b2Vec2 = new b2Vec2(0, 0);
 
        private var _world:b2World;
 
        //Physics params default value
        public var _friction:Number = 0.8; //0.8
        public var _restitution:Number = 0.3; //0.3
        public var _density:Number = 0.7; //0.7
 
        //Default angle
        public var _angle:Number = 0;
        //Default body type
        public var _type:uint = b2Body.b2_dynamicBody;
 
 
        public function B2FlxSprite(X:Number, Y:Number, Width:Number, Height:Number, w:b2World):void
        {
            super(X,Y);
 
            width = Width;
            height = Height;
            _world = w
        }
 
        override public function update():void
        {
            //x = (_obj.GetPosition().x * ratio) - width/2 ;
            //y = (_obj.GetPosition().y * ratio) - height/2;

			_obj.SetPosition(new b2Vec2((x + (width / 2)) / ratio, (y + (height / 2)) / ratio));
            angle = _obj.GetAngle() * (180 / Math.PI);
            super.update();
        }
 
        public function createBody():void
        {   
			// The shape is used to visualize the fixture, using debugDraw
            var boxShape:b2PolygonShape = new b2PolygonShape();
            boxShape.SetAsBox((width / 2) / ratio, (height / 2) / ratio);
 
            _fixDef = new b2FixtureDef();
            _fixDef.density = _density;
            _fixDef.restitution = _restitution;
            _fixDef.friction = _friction;                        
            _fixDef.shape = boxShape;
 
            _bodyDef = new b2BodyDef();
            _bodyDef.position.Set((x + (width/2)) / ratio, (y + (height/2)) / ratio);
            _bodyDef.angle = _angle * (Math.PI / 180);
            _bodyDef.type = _type;
			
			// Like the body coordinates, anchor coordinates are specified in world coordinates, atleast for the initialization distanceJoint
			_anchor.Set((x + (width / 2)) / ratio, (y + (height / 2)) / ratio);
 
            _obj = _world.CreateBody(_bodyDef);
            _obj.CreateFixture(_fixDef);
        }
    }
=======
package
{
    import org.flixel.*;
 
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
    import Box2D.Common.*;
	import Box2D.Common.Math.*;
	
 
    public class B2FlxSprite extends FlxSprite
    {
		// The before-mentioned ratio of pixels/meter
        private var ratio:Number = 30;
		// The fixture is used by the body of the sprite, and contains physics parameters such as friction, restitution and density
        public var _fixDef:b2FixtureDef;
		// Initially, the body needs a bodyDef, that specifies initial position, angle and type. The idea is that multiple bodies can use the same bodyDef, and that the bodyDef remains untouched after declaration
        public var _bodyDef:b2BodyDef
        public var _obj:b2Body;
		// The anchor point is used to specify the position within the body, that the joint should connect to
		public var _anchor:b2Vec2 = new b2Vec2(0, 0);
 
        private var _world:b2World;
 
        //Physics params default value
        public var _friction:Number = 0.8; //0.8
        public var _restitution:Number = 0.3; //0.3
        public var _density:Number = 0.7; //0.7
 
        //Default angle
        public var _angle:Number = 0;
        //Default body type
        public var _type:uint = b2Body.b2_dynamicBody;
 
 
        public function B2FlxSprite(X:Number, Y:Number, Width:Number, Height:Number, w:b2World):void
        {
            super(X,Y);
 
            width = Width;
            height = Height;
            _world = w
        }
 
        override public function update():void
        {
            //x = (_obj.GetPosition().x * ratio) - width/2 ;
            //y = (_obj.GetPosition().y * ratio) - height/2;

			_obj.SetPosition(new b2Vec2((x + (width / 2)) / ratio, (y + (height / 2)) / ratio));
            angle = _obj.GetAngle() * (180 / Math.PI);
            super.update();
        }
 
        public function createBody():void
        {   
			// The shape is used to visualize the fixture, using debugDraw
            var boxShape:b2PolygonShape = new b2PolygonShape();
            boxShape.SetAsBox((width / 2) / ratio, (height / 2) / ratio);
 
            _fixDef = new b2FixtureDef();
            _fixDef.density = _density;
            _fixDef.restitution = _restitution;
            _fixDef.friction = _friction;                        
            _fixDef.shape = boxShape;
 
            _bodyDef = new b2BodyDef();
            _bodyDef.position.Set((x + (width/2)) / ratio, (y + (height/2)) / ratio);
            _bodyDef.angle = _angle * (Math.PI / 180);
            _bodyDef.type = _type;
			
			// Like the body coordinates, anchor coordinates are specified in world coordinates, atleast for the initialization distanceJoint
			_anchor.Set((x + (width / 2)) / ratio, (y + (height / 2)) / ratio);
 
            _obj = _world.CreateBody(_bodyDef);
            _obj.CreateFixture(_fixDef);
        }
    }
>>>>>>> 1e1858570491895bac0fa8e6d347bd328ff188fb
}