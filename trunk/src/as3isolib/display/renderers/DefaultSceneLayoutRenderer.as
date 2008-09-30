package as3isolib.display.renderers
{
	import as3isolib.bounds.IBounds;
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.scene.IIsoScene;
	
	import flash.events.EventDispatcher;
	
	/**
	 * The DefaultSceneLayoutRenderer is the default renderer responsible for performing the isometric position-based depth sorting on the child objects of the target IIsoScene.
	 */
	public class DefaultSceneLayoutRenderer extends EventDispatcher implements ISceneRenderer
	{		
		////////////////////////////////////////////////////
		//	TARGET
		////////////////////////////////////////////////////
		
		private var targetContainer:IIsoScene;
		
		/**
		 * @private
		 */
		public function get target ():IIsoScene
		{
			return targetContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set target (value:IIsoScene):void
		{
			targetContainer = value;
		}
		
		////////////////////////////////////////////////////
		//	UPDATE LAYOUT
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderScene ():void
		{
			var sortedChildren:Array = targetContainer.children;
			sortedChildren.sort(isoDepthSort);
			
			var i:uint;
			var m:uint = sortedChildren.length;
			while (i < m)
			{
				targetContainer.setChildIndex(IIsoDisplayObject(sortedChildren[i]), i);
				i++;
			}
		}
		
		////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function DefaultSceneLayoutRenderer ()
		{
			super();
		}
		
		////////////////////////////////////////////////////
		//	SORT
		////////////////////////////////////////////////////
		
		private function isoDepthSort (childA:IIsoDisplayObject, childB:IIsoDisplayObject):int
		{
			var boundsA:IBounds = childA.isoBounds;
			var boundsB:IBounds = childB.isoBounds;
			
			if (childA.container.hitTestObject(childB.container))
			{
				if (boundsA.right <= boundsB.left)
					return -1;
					
				else if (boundsA.left >= boundsB.right)
					return 1;
				
				else if (boundsA.front <= boundsB.back)
					return -1;
					
				else if (boundsA.back >= boundsB.front)
					return 1;
					
				else if (boundsA.top <= boundsB.bottom)
					return -1;
					
				else if (boundsA.bottom >= boundsB.top)
					return 1;
				
				else
					return 0;
			}			
			
			//else simple positioning sort
			else
			{
				if (childA.screenY > childB.screenY)
					return 1;
					
				else if (childA.screenY < childB.screenY)
					return -1;
				
				else
				{
					if (childA.screenX > childB.screenX)
						return 1;
						
					else if (childA.screenX < childB.screenX)
						return -1;
						
					else 
						return 0;
				}
			}
		}
	}
}