sap.ui.define(["com/public/storage/pao/utils/reusecontroller","sap/m/BusyDialog","sap/m/MessageToast","com/public/storage/pao/utils/formatter","sap/ui/model/json/JSONModel"],function(e,t,s,o,l){"use strict";var n;return e.extend("com.public.storage.pao.c+
ontroller.WorkingHours",{formatter:o,onInit:function(){n=this;const e=this.getRouter();e.getRoute("workingHours").attachMatched(this._onRouteMatched,this);this._oBusyDialog=new t;this.getView().addDependent(this._oBusyDialog);this.model=new l;this.model.+
setData({sunOpenHR:"None",monOpenHR:"None",tueOpenHR:"None",wedOpenHR:"None",thuOpenHR:"None",friOpenHR:"None",satOpenHR:"None",sunCloseHR:"None",monCloseHR:"None",tueCloseHR:"None",wedCloseHR:"None",thuCloseHR:"None",friCloseHR:"None",satCloseHR:"None"}+
);this.getView().setModel(this.model)},onDetectChange:function(e){this.detectChanges()},_onRouteMatched:function(e){const t=this.getRouter();this.getOwnerComponent.hasChanges=false;const s=this.getOwnerComponent().plant;if(s===undefined){return t.navTo("+
home")}const o=this.getOwnerComponent().LegacyPropertyNumber;this._oModel=sap.ui.getCore().getModel("mainModel");this.readPropertyData(s,o)},onPressSaveWorkingHours:function(){this._oBusyDialog.open();const e=this;var t=true;const o=this.getOwnerComponen+
t().plant;const l=this.getOwnerComponent().LegacyPropertyNumber;let n=this.byId("daylight").getSelectedKey();let i=this.byId("sunOpen").getValue();let a=this.byId("monOpen").getValue();let r=this.byId("tueOpen").getValue();let u=this.byId("wedOpen").getV+
alue();let p=this.byId("thuOpen").getValue();let d=this.byId("friOpen").getValue();let h=this.byId("satOpen").getValue();let c=this.byId("sunClose").getValue();let m=this.byId("monClose").getValue();let H=this.byId("tueClose").getValue();let f=this.byId(+
"wedClose").getValue();let g=this.byId("thuClose").getValue();let y=this.byId("friClose").getValue();let O=this.byId("satClose").getValue();const C=(e,t)=>{if(e===""||e==null){this.model.setProperty(t,"Error")}else{this.model.setProperty(t,"None")}};cons+
t b=()=>{C(i,"/sunOpenHR");C(a,"/monOpenHR");C(r,"/tueOpenHR");C(u,"/wedOpenHR");C(p,"/thuOpenHR");C(d,"/friOpenHR");C(h,"/satOpenHR");C(c,"/sunCloseHR");C(m,"/monCloseHR");C(H,"/tueCloseHR");C(f,"/wedCloseHR");C(g,"/thuCloseHR");C(y,"/friCloseHR");C(O,"+
/satCloseHR")};b();if(i===""||a===""||r===""||u===""||p===""||d===""||h===""||c===""||m===""||H===""||f===""||g===""||y===""||O===""){t=true}else{t=false}if(t===false){let t=i.split(":").map(Number);let C=a.split(":").map(Number);let b=r.split(":").map(N+
umber);let N=u.split(":").map(Number);let R=p.split(":").map(Number);let M=d.split(":").map(Number);let S=h.split(":").map(Number);let P=c.split(":").map(Number);let w=m.split(":").map(Number);let T=H.split(":").map(Number);let I=f.split(":").map(Number)+
;let V=g.split(":").map(Number);let D=y.split(":").map(Number);let _=O.split(":").map(Number);let v="PT"+t[0]+"H"+t[1]+"M"+t[2]+"S";let B="PT"+C[0]+"H"+C[1]+"M"+C[2]+"S";let L="PT"+b[0]+"H"+b[1]+"M"+b[2]+"S";let W="PT"+N[0]+"H"+N[1]+"M"+N[2]+"S";let k="P+
T"+R[0]+"H"+R[1]+"M"+R[2]+"S";let F="PT"+M[0]+"H"+M[1]+"M"+M[2]+"S";let $="PT"+S[0]+"H"+S[1]+"M"+S[2]+"S";let j="PT"+P[0]+"H"+P[1]+"M"+P[2]+"S";let x="PT"+w[0]+"H"+w[1]+"M"+w[2]+"S";let A="PT"+T[0]+"H"+T[1]+"M"+T[2]+"S";let E="PT"+I[0]+"H"+I[1]+"M"+I[2]++
"S";let J="PT"+V[0]+"H"+V[1]+"M"+V[2]+"S";let K="PT"+D[0]+"H"+D[1]+"M"+D[2]+"S";let q="PT"+_[0]+"H"+_[1]+"M"+_[2]+"S";const z={OfficeSundayOpenHr:v,OfficeSundayCloseHr:j,OfficeMondayOpenHr:B,OfficeMondayCloseHr:x,OfficeTuesdayOpenHr:L,OfficeTuesdayCloseH+
r:A,OfficeWednessdayOpenHr:W,OfficeWednessdayCloseHr:E,OfficeThursdayOpenHr:k,OfficeThursdayCloseHr:J,OfficeFridayOpenHr:F,OfficeFridayCloseHr:K,OfficeSaturdayOpenHr:$,OfficeSaturdayCloseHr:q,DayLightSavingsApplicable:n};const G=`/PropertyMasterSet(Plant+
='${o}',LegacyPropertyNumber='${l}')`;this._oModel.update(G,z,{success:function(t){e._oBusyDialog.close();e.getOwnerComponent.hasChanges=false;s.show("Saved Successfully")},error:function(t){e._oBusyDialog.close();s.show("Something went wrong with Servic+
e")}})}else{this._oBusyDialog.close();s.show("Please Fill all mandatory fields")}}})});                                                                                                                                                                        
//# sourceMappingURL=WorkingHours.controller.js.map                                                                                                                                                                                                            