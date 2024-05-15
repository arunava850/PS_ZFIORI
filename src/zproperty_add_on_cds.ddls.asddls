@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZProperty Add On'
@Metadata.allowExtensions: true

/*
@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true
@ObjectModel.transactionalProcessingEnabled: true */

@OData.publish: true

@UI: {
  headerInfo: { typeName: 'Property Add On Report',
                typeNamePlural: 'Property Add on',
                title: { type: #STANDARD, label: 'ZProperty Report2',
                value: 'plant' } }
              }

define root view entity ZPROPERTY_ADD_ON_CDS
  as select distinct from zproperty_add_on as _zprop


{
key _zprop.plant as Plant,
key _zprop.property as Property,
key _zprop.key_id as KeyId,
key _zprop.code as Code,
_zprop.value1 as Value1,
_zprop.value2 as Value2,
_zprop.description1 as Description1,
_zprop.description2 as Description2,
_zprop.changed_by as ChangedBy,
_zprop.changed_date as ChangedDate,
_zprop.changed_time as ChangedTime

}
