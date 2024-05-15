sap.ui.define(["com/public/storage/pao/utils/reusecontroller","sap/m/BusyDialog","sap/m/MessageToast","sap/ui/model/json/JSONModel","com/public/storage/pao/utils/formatter"],function(e,t,i,n,s){"use strict";var l;return e.extend("com.public.storage.pao.c+
ontroller.InsuranceDetails",{formatter:s,onInit:function(){l=this;const e=this.getRouter();e.getRoute("insDetails").attachMatched(this._onRouteMatched,this);this._oBusyDialog=new t;this.getView().addDependent(this._oBusyDialog);this.model=new n;this.mode+
l.setData({ErentalMaxDays:"None",CddStartDate:"None"});this.getView().setModel(this.model)},_onRouteMatched:function(e){const t=this.getRouter();this.getOwnerComponent.hasChanges=false;const i=this.getOwnerComponent().plant;if(i===undefined){return t.nav+
To("home")}const n=this.getOwnerComponent().LegacyPropertyNumber;this._oModel=sap.ui.getCore().getModel("mainModel");this.readPropertyData(i,n)},onDetectChange:function(e){this.detectChanges()},onPressSaveInsuranceDetails:function(){this._oBusyDialog.ope+
n();const e=this;const t=this.getOwnerComponent().plant;const n=this.getOwnerComponent().LegacyPropertyNumber;let s="T00:00:00";var l=true;let r=this.byId("startdate").getValue().split(".").reverse().join("-");let o=this.byId("finrepD3").getValue().split+
(".").reverse().join("-");let a=this.byId("finrepD4").getValue().split(".").reverse().join("-");let p=this.byId("finrepD5").getValue().split(".").reverse().join("-");let u=this.byId("finrepD6").getValue().split(".").reverse().join("-");let g=this.byId("f+
inrepD7").getValue().split(".").reverse().join("-");let h=this.byId("finrepD8").getValue().split(".").reverse().join("-");let d=this.byId("finrepD9").getValue().split(".").reverse().join("-");let D=this.byId("finrepD10").getValue().split(".").reverse().j+
oin("-");let c=o===""?s:new Date(o).toISOString().split("T")[0]+s;let y=a===""?s:new Date(a).toISOString().split("T")[0]+s;let m=p===""?s:new Date(p).toISOString().split("T")[0]+s;let w=u===""?s:new Date(u).toISOString().split("T")[0]+s;let I=g===""?s:ne+
w Date(g).toISOString().split("T")[0]+s;let f=h===""?s:new Date(h).toISOString().split("T")[0]+s;let V=d===""?s:new Date(d).toISOString().split("T")[0]+s;let S=D===""?s:new Date(D).toISOString().split("T")[0]+s;let b=r===""?s:new Date(r).toISOString().sp+
lit("T")[0]+s;o=c==="T00:00:00"?null:c;a=y==="T00:00:00"?null:y;p=m==="T00:00:00"?null:m;u=w==="T00:00:00"?null:w;g=I==="T00:00:00"?null:I;h=f==="T00:00:00"?null:f;d=V==="T00:00:00"?null:V;D=S==="T00:00:00"?null:S;r=b==="T00:00:00"?null:b;let T=this.getV+
iew().byId("insprem2").getValue();let O=this.getView().byId("insprem3").getValue();let v=this.getView().byId("insprem4").getValue();let F=this.getView().byId("insprem5").getValue();let M=this.getView().byId("eRental").getValue();if(M===null||M===""){this+
.model.setProperty("/ErentalMaxDays","Error")}else{this.model.setProperty("/ErentalMaxDays","None")}if(M===""){l=true}else{l=false}if(l===false){const s={FinrepNum1:this.getView().byId("finrep1").getValue(),FinrepNum2:this.getView().byId("finrep2").getVa+
lue(),InsPrem2000:T,InsPrem3000:O,InsPrem4000:v,InsPrem5000:F,FinrepNum7:this.getView().byId("finrep7").getValue(),FinrepNum8:this.getView().byId("finrep8").getValue(),FinrepNum9:this.getView().byId("finrep9").getValue(),ErentalMaxDays:M,FinrepDate2:r,Fi+
nrepDate3:o,FinrepDate4:a,FinrepDate5:p,FinrepDate6:u,FinrepDate7:g,FinrepDate8:h,FinrepDate9:d,FinrepDate10:D};const l=`/PropertyMasterSet(Plant='${t}',LegacyPropertyNumber='${n}')`;this._oModel.update(l,s,{success:function(t){e._oBusyDialog.close();e.g+
etOwnerComponent.hasChanges=false;i.show("Saved Successfully")},error:function(t){e._oBusyDialog.close();i.show("Something went wrong with Service")}})}else{this._oBusyDialog.close();i.show("Please Fill all mandatory fields")}}})});                       
//# sourceMappingURL=InsuranceDetails.controller.js.map                                                                                                                                                                                                        