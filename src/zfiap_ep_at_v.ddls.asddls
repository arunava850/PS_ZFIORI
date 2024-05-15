@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment View'
define root view entity ZFIAP_EP_AT_V
  as select from zfiap_ep_data_at
//  association to parent ZFIAP_EP_DATA_ATT as _header on $projection.edi_trans_no = _header.edi_trans_no
{

      //  key att_id       as att_id,
      @EndUserText.label: 'EDI Trans No'
  key edi_trans_no as edi_trans_no,
      @EndUserText.label: 'Attachment Description'
      attachment   as attachment,
      @EndUserText.label: 'File Type'
      mimetype     as mimetype,
      @EndUserText.label: 'Attachment'
      @Semantics.largeObject:
      { mimeType: 'mimetype',
      fileName: 'attachment',
      contentDispositionPreference: #INLINE }
      attfile      as attfile
//      _header // Make association public
}

//In child entity "ZFIAP_EP_AT_V" of "ZFIAP_EP_DATA_ATT" the "association to parent" is missing.
