@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZProperty Help'
@Metadata.allowExtensions: true

/*
@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true
@ObjectModel.transactionalProcessingEnabled: true */

@OData.publish: true

@UI: {
  headerInfo: { typeName: 'Property Help Report',
                typeNamePlural: 'Property Help',
                title: { type: #STANDARD, label: 'ZProperty Report2',
                value: 'keyfield' } }
              }

define root view entity ZPROPERTY_HELP_CDS
  as select distinct from zproperty_help as _zprop


{

key _zprop.keyfield as Keyfield,
key _zprop.code as Code,
_zprop.description as Description,
_zprop.in_active_flag as InActiveFlag,
_zprop.changed_by as ChangedBy,
_zprop.changed_date as ChangedDate,
_zprop.changed_time as ChangedTime

}
