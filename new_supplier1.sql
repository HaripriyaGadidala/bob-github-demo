DECLARE
   l_vendor_rec        AP_VENDOR_PUB_PKG.r_vendor_rec_type;
   l_vendor_id         NUMBER;
   l_party_id          NUMBER;
   l_return_status     VARCHAR2(1);
   l_msg_count         NUMBER;
   l_msg_data          VARCHAR2(2000);
BEGIN
   -- Populate supplier details
   l_vendor_rec.vendor_name   := 'ABC SUPPLIERS LTD';
   l_vendor_rec.vendor_type_lookup_code := 'STANDARD';
   l_vendor_rec.segment1      := 'ABC002';
   l_vendor_rec.start_date_active := SYSDATE;
   l_vendor_rec.taxpayer_id   := 'TAX12345';

   -- Call API
   AP_VENDOR_PUB_PKG.create_vendor (
       p_api_version   => 1.0,
       p_init_msg_list => FND_API.G_TRUE,
       p_commit        => FND_API.G_FALSE,
       p_vendor_rec    => l_vendor_rec,
       x_vendor_id     => l_vendor_id,
       x_party_id      => l_party_id,
       x_return_status => l_return_status,
       x_msg_count     => l_msg_count,
       x_msg_data      => l_msg_data
   );

   IF l_return_status = FND_API.G_RET_STS_SUCCESS THEN
      DBMS_OUTPUT.put_line('Supplier Created: Vendor ID = ' || l_vendor_id);
      COMMIT;
   ELSE
      DBMS_OUTPUT.put_line('Error: ' || l_msg_data);
      ROLLBACK;
   END IF;
END;
/