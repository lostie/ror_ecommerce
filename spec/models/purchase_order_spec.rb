require 'spec_helper'

describe PurchaseOrder do
  before(:each) do
    @purchase_order = Factory.build(:purchase_order)
  end
  
  it "should be valid with minimum attribues" do
    @purchase_order.should be_valid
  end
end

describe PurchaseOrder, ".display_received" do
  it "should return Yes when true" do
    order = Factory.build(:purchase_order)
    order.stubs(:is_received).returns(true)

    order.display_received == "Yes"
  end
end

describe PurchaseOrder, ".display_received" do
  it "should return No when false" do
    order = Factory.build(:purchase_order)
    order.stubs(:is_received).returns(false)

    order.display_received == "No"
  end
end

describe PurchaseOrder, ".display_estimated_arrival_on" do
  it "should return the correct name" do
    order = Factory.build(:purchase_order)
    now = Time.now
    order.stubs(:estimated_arrival_on).returns(now.to_date)

    order.display_estimated_arrival_on == now.to_s(:us_date)
  end
end

describe PurchaseOrder, ".supplier_name" do
  it "should return the correct name" do
    order = Factory.build(:purchase_order)
    supplier = Factory.build(:supplier)
    supplier.stubs(:name).returns("Supplier Test")
    order.stubs(:supplier).returns(supplier)

    order.supplier_name == "Supplier Test"
  end
end

describe PurchaseOrder, 'instance methods' do
  before(:each) do
    @purchase_order = Factory(:purchase_order, :state => 'pending')
    @purchase_order.purchase_order_variants.push(Factory(:purchase_order_variant, :purchase_order => @purchase_order, :is_received => false))
  end

  context ".receive_po=(answer)" do
    it 'should call receive_variants' do
      @purchase_order.expects(:receive_variants).once
      @purchase_order.receive_po=('1')
    end
    
    it 'should call receive_variants' do
      @purchase_order.expects(:receive_variants).once
      @purchase_order.receive_po=('true')
    end
    
    it 'should not call receive_variants' do
      @purchase_order.expects(:receive_variants).never
      @purchase_order.receive_po=('0')
    end
    
    it 'should not call receive_variants' do
      @purchase_order.state = 'received'
      @purchase_order.expects(:receive_variants).never
      @purchase_order.receive_po=('1')
    end
  end

  context ".receive_po" do
    it 'should return true if state is received' do
      @purchase_order.state = PurchaseOrder::RECEIVED
      @purchase_order.receive_po.should be_true
    end
    
    it 'should return false if state is not received' do
      @purchase_order.state = PurchaseOrder::PENDING
      @purchase_order.receive_po.should be_false
    end
  end

  context ".display_tracking_number" do
    it 'should display N/A if the tracking number is nil' do
      @purchase_order.tracking_number = nil
      @purchase_order.display_tracking_number.should == 'N/A'
    end
  end
end

describe PurchaseOrder, ".receive_variants" do
  it 'should receive PO_varaints ' do
    purchase_order = Factory(:purchase_order, :state => 'pending')
    purchase_order.purchase_order_variants.push(Factory(:purchase_order_variant, :purchase_order => purchase_order, :is_received => false))
    PurchaseOrderVariant.any_instance.expects(:receive!).once
    purchase_order.receive_variants
  end
  
  it 'should not receive PO_varaints ' do
    purchase_order = Factory(:purchase_order, :state => 'pending')
    purchase_order.purchase_order_variants.push(Factory(:purchase_order_variant, :purchase_order => purchase_order, :is_received => true))
    PurchaseOrderVariant.any_instance.expects(:receive!).never
    purchase_order.receive_variants
  end
end

describe PurchaseOrder, "#admin_grid(params = {})" do
  pending "test for admin_grid(params = {})"
end

describe PurchaseOrder, "#receiving_admin_grid(params = {})" do
  pending "test for receiving_admin_grid(params = {})"
end
