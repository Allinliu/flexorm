package ormtest.model
{
	import mx.collections.IList;
	
	[Bindable]
	[Table(name="contacts")]
	public dynamic class Contact
	{
		private var _orders:IList;
		
		[Id]
		[Column(name="id")]
		public var id:int;
		
		[Column(name="name")]
		public var name:String;
		
		[ManyToOne]
		public var organisation:Organisation;
		
		[OneToMany(type="ormtest.model.Order", cascade="save-update")]
		public function set orders(value:IList):void
		{
			_orders = value;
			for each(var order:Order in value)
			{
				order.contact = this;
			}
		}
		
		public function get orders():IList
		{
			return _orders;
		}
		
		[ManyToMany(type="ormtest.model.Role")]
		public var roles:IList;

	}
}