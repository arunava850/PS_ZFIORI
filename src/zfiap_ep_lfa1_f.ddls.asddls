@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LFA1 Details projection Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFIAP_EP_LFA1_F
  as select from ZFIAP_EP_LFA1
{
  key Lifnr,
      Name1,
      Name2,
      Name3,
      Stras,
      Title,
      StrSuppl1,
      Ort01,
      Regio,
      Pstlz,
      Country,
      Stcd1,
      Stcd2,
      fullname,
      namelegth,
      firstn,
      lastn,
      case
        when instr(lastn, ' ') = 0
          then ''
        when instr(lastn, ' ') = 1
          then ''
        when instr(lastn, ' ') = 2
          then left(lastn, 1)
        when instr(lastn, ' ') = 3
          then left(lastn, 2)
        when instr(lastn, ' ') = 4
          then left(lastn, 3)
        when instr(lastn, ' ') = 5
          then left(lastn, 4)
        when instr(lastn, ' ') = 6
          then left(lastn, 5)
        when instr(lastn, ' ') = 7
          then left(lastn, 6)
        when instr(lastn, ' ') = 8
          then left(lastn, 7)
        when instr(lastn, ' ') = 9
          then left(lastn, 8)
        when instr(lastn, ' ') = 10
          then left(lastn, 9)
        when instr(lastn, ' ') = 11
          then left(lastn, 10)
        when instr(lastn, ' ') = 12
          then left(lastn, 11)
        when instr(lastn, ' ') = 13
          then left(lastn, 12)
        when instr(lastn, ' ') = 14
          then left(lastn, 13)
        when instr(lastn, ' ') = 15
          then left(lastn, 14)
        when instr(lastn, ' ') = 16
          then left(lastn, 15)
        when instr(lastn, ' ') = 17
          then left(lastn, 16)
        when instr(lastn, ' ') = 18
          then left(lastn, 17)
        when instr(lastn, ' ') = 19
          then left(lastn, 18)
        when instr(lastn, ' ') = 20
          then left(lastn, 19)
        when instr(lastn, ' ') = 21
          then left(lastn, 20)
        else lastn
        end as middlen,
        
              case
        when instr(lastn, ' ') = 0
          then lastn
        when instr(lastn, ' ') = 1
          then lastn
                  when instr(lastn, ' ') = 2
          then (right(lastn, (length(lastn) - 2) ))
        when instr(lastn, ' ') = 3
          then (right(lastn, (length(lastn) - 3) ))
                  when instr(lastn, ' ') = 4
          then (right(lastn, (length(lastn) - 4) ))
                  when instr(lastn, ' ') = 5
          then (right(lastn, (length(lastn) - 5) ))
                  when instr(lastn, ' ') = 6
          then (right(lastn, (length(lastn) - 6) ))
                  when instr(lastn, ' ') = 7
          then (right(lastn, (length(lastn) - 7) ))
                  when instr(lastn, ' ') = 8
          then (right(lastn, (length(lastn) - 8) ))
                  when instr(lastn, ' ') = 9
          then (right(lastn, (length(lastn) - 9) ))
                  when instr(lastn, ' ') = 10
          then (right(lastn, (length(lastn) - 10) ))
                  when instr(lastn, ' ') = 11
          then (right(lastn, (length(lastn) - 11) ))
                  when instr(lastn, ' ') = 12
          then (right(lastn, (length(lastn) - 12) ))
                  when instr(lastn, ' ') = 13
          then (right(lastn, (length(lastn) - 13) ))
                  when instr(lastn, ' ') = 14
          then (right(lastn, (length(lastn) - 14) ))
                  when instr(lastn, ' ') = 15
          then (right(lastn, (length(lastn) - 15) ))
                  when instr(lastn, ' ') = 16
          then (right(lastn, (length(lastn) - 16) ))
                  when instr(lastn, ' ') = 17
          then (right(lastn, (length(lastn) - 17) ))
                  when instr(lastn, ' ') = 18
          then (right(lastn, (length(lastn) - 18) ))
                  when instr(lastn, ' ') = 19
          then (right(lastn, (length(lastn) - 19) ))
                  when instr(lastn, ' ') = 20
          then (right(lastn, (length(lastn) - 20) ))
                  when instr(lastn, ' ') = 21
          then (right(lastn, (length(lastn) - 21) ))
                  when instr(lastn, ' ') = 22
          then (right(lastn, (length(lastn) - 22) ))
          else lastn
          end as lastnnew
}
