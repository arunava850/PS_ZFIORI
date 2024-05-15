@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection on EP Attachment'
define root view entity ZFIAP_EP_AT_VP
  as projection on ZFIAP_EP_AT_V

{

//  key att_id,
  key    edi_trans_no,
      attachment,
      mimetype,
      attfile
      /* Associations */
      //   _header: redirected to ZFIAP_EP_DATA_PR
}
