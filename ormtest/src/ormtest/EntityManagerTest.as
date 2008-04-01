package ormtest
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;
	
	import nz.co.codec.flexorm.EntityManager;
	
	import ormtest.model.Contact;
	import ormtest.model.Order;
	import ormtest.model.Organisation;
	import ormtest.model.Role;

	public class EntityManagerTest extends TestCase
	{
		private var em:EntityManager = EntityManager.instance;
		
		public static function suite():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			ts.addTest(new EntityManagerTest("testSaveSimpleObject"));
			ts.addTest(new EntityManagerTest("testFindAll"));
			ts.addTest(new EntityManagerTest("testSaveManyToOneAssociation"));
			ts.addTest(new EntityManagerTest("testSaveOneToManyAssociations"));
			ts.addTest(new EntityManagerTest("testSaveManyToManyAssociation"));
			ts.addTest(new EntityManagerTest("testDelete"));
			ts.addTest(new EntityManagerTest("testCascadeSaveUpdate"));
			return ts;
		}
		
		public function EntityManagerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testSaveSimpleObject():void
		{
			var organisation:Organisation = new Organisation();
			organisation.name = "Codec Group Limited";
			em.save(organisation);
			
			var loadedOrganisation:Organisation = em.loadItem(Organisation, organisation.id) as Organisation;
			assertEquals(loadedOrganisation.name, "Codec Group Limited");
		}
		
		public function testFindAll():void
		{
			var organisation:Organisation = new Organisation();
			organisation.name = "Adobe";
			em.save(organisation);
			
			var organisations:ArrayCollection = em.findAll(Organisation);
			assertEquals(organisations.length, 2);
		}
		
		public function testSaveManyToOneAssociation():void
		{
			var organisation:Organisation = new Organisation();
			organisation.name = "Apple";
			
			var contact:Contact = new Contact();
			contact.name = "Steve";
			contact.organisation = organisation;
			em.save(contact);
			
			var loadedContact:Contact = em.loadItem(Contact, contact.id) as Contact;
			assertNotNull(loadedContact);
			assertNotNull(loadedContact.organisation);
			assertEquals(loadedContact.organisation.name, "Apple");
		}
		
		public function testSaveOneToManyAssociations():void
		{
			var orders:ArrayCollection = new ArrayCollection();
			
			var order1:Order = new Order();
			order1.item = "Flex Builder 3";
			
			var order2:Order = new Order();
			order2.item = "CS3 Fireworks";
			
			orders.addItem(order1);
			orders.addItem(order2);
			
			var contact:Contact = new Contact();
			contact.name = "Greg";
			contact.orders = orders;
			em.save(contact);
			
			var loadedContact:Contact = em.loadItem(Contact, contact.id) as Contact;
			assertEquals(loadedContact.orders.length, 2);
		}
		
		public function testSaveManyToManyAssociation():void
		{
			var roles:ArrayCollection = new ArrayCollection();
			
			var role1:Role = new Role();
			role1.name = "Project Manager";
			
			var role2:Role = new Role();
			role2.name = "Business Analyst";
			
			roles.addItem(role1);
			roles.addItem(role2);
			
			var contact:Contact = new Contact();
			contact.name = "Shannon";
			contact.roles = roles;
			em.save(contact);
			
			var loadedContact:Contact = em.loadItem(Contact, contact.id) as Contact;
			assertEquals(loadedContact.roles.length, 2);
		}
		
		public function testDelete():void
		{
			var organisation:Organisation = new Organisation();
			organisation.name = "Datacom";
			em.save(organisation);
			
			em.remove(organisation);
			var loadedOrganisation:Organisation = em.loadItem(Organisation, organisation.id) as Organisation;
			assertNull(loadedOrganisation);
		}
		
		public function testCascadeSaveUpdate():void
		{
			var orders:ArrayCollection = new ArrayCollection();
			
			var order1:Order = new Order();
			order1.item = "Bach";
			
			var order2:Order = new Order();
			order2.item = "BMW";
			
			orders.addItem(order1);
			orders.addItem(order2);
			
			var contact:Contact = new Contact();
			contact.name = "Jen";
			contact.orders = orders; // cascade="save-update"
			em.save(contact);
			
			var orderId:int = order2.id;
			
			// verify that cascade save-update works
			assertTrue(orderId > 0);
			
			em.remove(contact);
			
			// verify that cascade delete is not in effect
			var loadedOrder:Order = em.loadItem(Order, orderId) as Order;
			assertEquals(loadedOrder.item, "BMW");
		}
		
	}
}