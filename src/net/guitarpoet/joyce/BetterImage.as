package net.guitarpoet.joyce {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	
	import net.guitarpoet.joyce.loader.BufferedLoader;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the <code>data</code> property changes.
	 *
	 *  <p>When you use a component as an item renderer,
	 *  the <code>data</code> property contains the data to display.
	 *  You can listen for this event and update the component
	 *  when the <code>data</code> property changes.</p>
	 * 
	 *  @eventType mx.events.FlexEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[DefaultBindingProperty(source="progress", destination="source")]
	
	[DefaultTriggerEvent("complete")]
	
	[IconFile("Image.png")]
	/**
	 * The better image object for flex.
	 *  
	 * @author jack
	 * 
	 */
	public class BetterImage extends BufferedLoader implements IDataRenderer, 
		IDropInListItemRenderer, IListItemRenderer {
			
		//--------------------------------------------------------------------------
	    //
	    //  Variables
	    //
	    //--------------------------------------------------------------------------
	
	    protected var makeContentVisible:Boolean = false;
	    
	    /**
	     *  Flag that will block default data/listData behavior
	     */
	    protected var sourceSet:Boolean;
	
	    /**
	     *  Flag that will block invalidation when a renderer
	     */
	    protected var settingBrokenImage:Boolean;
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden properties
	    //
	    //--------------------------------------------------------------------------
	    
	    //----------------------------------
	    //  source
	    //----------------------------------
	
	
	    [Bindable("sourceChanged")]
	    [Inspectable(category="General", defaultValue="", format="File")]

	    override public function set source(value:Object):void {
	        settingBrokenImage = (value == getStyle("brokenImageSkin"));
	        sourceSet = !settingBrokenImage;
	        super.source = value;
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Properties
	    //
	    //--------------------------------------------------------------------------
	    
	    //----------------------------------
	    //  data
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Storage for the data property.
	     */
	    private var _data:Object;
	
	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]
	
	    /**
	     *  The <code>data</code> property lets you pass a value to the component
	     *  when you use it in an item renderer or item editor. 
	     *  You typically use data binding to bind a field of the <code>data</code> 
	     *  property to a property of this component.
	     *
	     *  <p>When you use the control as a drop-in item renderer, Flex 
	     *  will use the <code>listData.label</code> property, if it exists,
	     *  as the value of the <code>source</code> property of this control, or
	     *  use the <code>data</code> property as the <code>source</code> property.</p>
	     *
	     *  @default null
	     *  @see mx.core.IDataRenderer
	     */
	    public function get data():Object {
	        return _data;
	    }
	    
	    private var _smooth : Boolean = true;
	    
	    [Bindable("smoothChange")]
		[Inspectable(environment="none")]
		
		/**
		 * Use image smooth when rendering.
		 *   
		 * @return 
		 * 
		 */
		public function get smooth() : Boolean {
			return _smooth;
		}
		
		public function set smooth(s : Boolean) : void {
			_smooth = s;
			dispatchEvent(new FlexEvent("smoothChange"));
		}
	    /**
	     *  @private
	     */
	    public function set data(value:Object):void {
	        _data = value;
	        
	        if (!sourceSet) {
	            source = listData ? listData.label : data;
	            sourceSet = false;
	        }
	
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	    }
	    
	    //----------------------------------
	    //  listData
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Storage for the listData property.
	     */
	    private var _listData:BaseListData;
	
	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]
	
	    /**
	     *  When a component is used as a drop-in item renderer or drop-in
	     *  item editor, Flex initializes the <code>listData</code> property
	     *  of the component with the appropriate data from the List control.
	     *  The component can then use the <code>listData</code> property
	     *  to initialize the other properties of the drop-in
	     *  item renderer
	     *
	     *  <p>You do not set this property in MXML or ActionScript;
	     *  Flex sets it when the component is used as a drop-in item renderer
	     *  or drop-in item editor.</p>
	     *
	     *  @default null
	     *  @see mx.controls.listClasses.IDropInListItemRenderer
	     */
	    public function get listData():BaseListData {
	        return _listData;
	    }
	
	    /**
	     *  @private
	     */
	    public function set listData(value:BaseListData):void {
	        _listData = value;
	    }
	    
		public function BetterImage() {
			// images are generally not interactive
	        tabChildren = false;
	        tabEnabled = true;
	        
	        showInAutomationHierarchy = true;     
		}
		

	    //--------------------------------------------------------------------------
	    //
	    //  Inherited methods : UIComponent
	    //
	    //--------------------------------------------------------------------------

	    override public function invalidateSize():void {
	        if (data && settingBrokenImage) {
	            // don't invalidate otherwise we'll reload and loop forever
	            return;
	        }
	
	        super.invalidateSize();
	    }

	    override protected function updateDisplayList(unscaledWidth:Number,
	                                                  unscaledHeight:Number):void {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        
	        if (makeContentVisible && contentHolder) {
	            contentHolder.visible = true;
	            makeContentVisible = false;
	        }
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Inherited event handlers: BufferedLoader
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     * @param event
	     * 
	     */
	    override protected function contentLoaderInfo_completeEventHandler(
	                                        event:Event):void {
	        var loader:Loader = event.target.loader as Loader;
	        
	        if(smooth)
	        	Bitmap(loader.content).smoothing = true;
	
	        super.contentLoaderInfo_completeEventHandler(event);
	        
	        // Hide the object until draw
	        loader.visible = false;
	        makeContentVisible = true;
	        invalidateDisplayList();
	    }
	}
}