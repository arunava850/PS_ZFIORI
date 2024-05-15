@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LFA1 Details projection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFIAP_EP_LFA1
  as select from ZFIAP_EP_VEND
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
      case
      when instr(fullname, ' ') = 0
        then ''
      when instr(fullname, ' ') = 1
        then ''

        when instr(fullname, ' ') = 2
            then left(fullname, 1)
        when instr(fullname, ' ') = 3
            then left(fullname, 2)
        when instr(fullname, ' ') = 4
            then left(fullname, 3)
        when instr(fullname, ' ') = 5
            then left(fullname, 4)
        when instr(fullname, ' ') = 6
            then left(fullname, 5)
        when instr(fullname, ' ') = 7
            then left(fullname, 6)
        when instr(fullname, ' ') = 8
            then left(fullname, 7)
        when instr(fullname, ' ') = 9
            then left(fullname, 8)
        when instr(fullname, ' ') = 10
            then left(fullname, 9)
        when instr(fullname, ' ') = 11
            then left(fullname, 10)
        when instr(fullname, ' ') = 12
            then left(fullname, 11)
        when instr(fullname, ' ') = 13
            then left(fullname, 12)
        when instr(fullname, ' ') = 14
            then left(fullname, 13)
        when instr(fullname, ' ') = 15
            then left(fullname, 14)
        when instr(fullname, ' ') = 16
            then left(fullname, 15)
        when instr(fullname, ' ') = 17
            then left(fullname, 16)
        when instr(fullname, ' ') = 18
            then left(fullname, 17)
        when instr(fullname, ' ') = 19
            then left(fullname, 18)
        when instr(fullname, ' ') = 20
            then left(fullname, 19)
        when instr(fullname, ' ') = 21
            then left(fullname, 20)
      else
      fullname
      end   as firstn,
      case
        when instr(fullname, ' ') = 0
          then ''
        when instr(fullname, ' ') = 1
          then ''
       when instr(fullname, ' ') = 2
          then (right(fullname, (namelegth - 2) ))
       when instr(fullname, ' ') = 3
          then (right(fullname, (namelegth - 3) ))
               when instr(fullname, ' ') = 4
          then (right(fullname, (namelegth - 4) ))
               when instr(fullname, ' ') = 5
          then (right(fullname, (namelegth - 5) ))
               when instr(fullname, ' ') = 6
          then (right(fullname, (namelegth - 6) ))
               when instr(fullname, ' ') = 7
          then (right(fullname, (namelegth - 7) ))
               when instr(fullname, ' ') = 8
          then (right(fullname, (namelegth - 8) ))
               when instr(fullname, ' ') = 9
          then (right(fullname, (namelegth - 9) ))
               when instr(fullname, ' ') = 10
          then (right(fullname, (namelegth - 10) ))
               when instr(fullname, ' ') = 11
          then (right(fullname, (namelegth - 11) ))
               when instr(fullname, ' ') = 12
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 13
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 14
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 15
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 16
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 17
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 18
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 19
         then (right(fullname, (namelegth - 12) ))
                      when instr(fullname, ' ') = 20
         then (right(fullname, (namelegth - 12) ))
         else
         fullname
        end as lastn
}
