sap.ui.define(["com/public/storage/paoro/utils/reusecontroller","sap/m/BusyDialog","sap/m/MessageToast","sap/ui/core/Fragment","sap/ui/model/json/JSONModel","com/public/storage/paoro/utils/formatter","sap/ui/model/Filter","sap/ui/model/FilterOperator","s+
ap/ui/model/FilterType"],function(e,t,o,i,n,s,a,r,l){"use strict";var u;return e.extend("com.public.storage.paoro.controller.MarketingDetails",{formatter:s,onInit:function(){u=this;const e=this.getRouter();e.getRoute("marketingDetails").attachMatched(thi+
s._onRouteMatched,this);this._oBusyDialog=new t;this.getView().addDependent(this._oBusyDialog);this.model=new n;this.model.setData({MarketKey:"None",MetroStatisicalArea:"None",Neighborwood:"None",PsConsolidatedPropertygroup:"None"});this.getView().setMod+
el(this.model)},_onRouteMatched:function(e){const t=this.getRouter();this.getOwnerComponent.hasChanges=false;const o=this.getOwnerComponent().plant;if(o===undefined){return t.navTo("home")}const i=this.getOwnerComponent().LegacyPropertyNumber;this._oMode+
l=sap.ui.getCore().getModel("mainModel");this.readPropertyData(o,i);this.readMarketKey();this.readMetroStatArea();this.readNeighborhood();this.readSameStore()},onValueHelpDialogSearchSameStore:function(e){let t=e.getParameter("value");let o=new a("Descri+
ption",r.Contains,t);let i=new a("Code",r.Contains,t);let n=new a({filters:[o,i],and:false});e.getSource().getBinding("items").filter([n])},onValueHelpDialogSearchMarketKey:function(e){let t=e.getParameter("value");let o=new a("Description",r.Contains,t)+
;let i=new a("Code",r.Contains,t);let n=new a({filters:[o,i],and:false});e.getSource().getBinding("items").filter([n])},onValueHelpDialogSearchMetroStats:function(e){let t=e.getParameter("value");let o=new a("Description",r.Contains,t);let i=new a("Code"+
,r.Contains,t);let n=new a({filters:[o,i],and:false});e.getSource().getBinding("items").filter([n])},onValueHelpDialogSearchNeighbour:function(e){let t=e.getParameter("value");let o=new a("Description",r.Contains,t);let i=new a("Code",r.Contains,t);let n+
=new a({filters:[o,i],and:false});e.getSource().getBinding("items").filter([n])},_onValueHelpMarketKey:function(e){this.getOwnerComponent.hasChanges=true;const t=this;const o=this.getView();if(!this._pValueHelpMarketKey){this._pValueHelpMarketKey=i.load(+
{id:o.getId(),name:"com.public.storage.paoro.fragments.MarketingDetails.MarketKey",controller:this}).then(function(e){o.addDependent(e);return e})}this._oBusyDialog.open();this._pValueHelpMarketKey.then(function(e){t._oBusyDialog.close();e.open()})},_onV+
alueHelpMetroStats:function(){this.getOwnerComponent.hasChanges=true;const e=this;const t=this.getView();if(!this._pValueHelpMetroStats){this._pValueHelpMetroStats=i.load({id:t.getId(),name:"com.public.storage.paoro.fragments.MarketingDetails.MetroStats"+
,controller:this}).then(function(e){t.addDependent(e);return e})}this._oBusyDialog.open();this._pValueHelpMetroStats.then(function(t){e._oBusyDialog.close();t.open()})},_onValueHelpNeigbour:function(e){this.getOwnerComponent.hasChanges=true;const t=this;+
const o=this.getView();if(!this._pValueHelpNeigbour){this._pValueHelpNeigbour=i.load({id:o.getId(),name:"com.public.storage.paoro.fragments.MarketingDetails.Neighbour",controller:this}).then(function(e){o.addDependent(e);return e})}this._oBusyDialog.open+
();this._pValueHelpNeigbour.then(function(e){t._oBusyDialog.close();e.open()})},_onValueHelpConslidated:function(){this.getOwnerComponent.hasChanges=true;const e=this;const t=this.getView();if(!this._pValueHelpConslidated){this._pValueHelpConslidated=i.l+
oad({id:t.getId(),name:"com.public.storage.paoro.fragments.MarketingDetails.SameStore",controller:this}).then(function(e){t.addDependent(e);return e})}this._oBusyDialog.open();this._pValueHelpConslidated.then(function(t){e._oBusyDialog.close();t.open()})+
},onDetectChange:function(e){this.detectChanges()},onValueHelpDialogClose:function(e){let t=e.getParameter("selectedItem");let o=e.getSource().getTitle();if(!t){return}let i=t.getDescription();let n=t.getTitle();if(o==="Market Key"){this.getView().getMod+
el("plantBasicDetailsModel").setProperty("/MarketKey",`(${n}) ${i}`)}else if(o==="Metro Statistical Area"){this.getView().getModel("plantBasicDetailsModel").setProperty("/MetroStatisicalArea",`(${n}) ${i}`)}else if(o==="Neighbourhood"){this.getView().get+
Model("plantBasicDetailsModel").setProperty("/Neighborwood",`(${n}) ${i}`)}else if(o==="Same Store"){this.getView().getModel("plantBasicDetailsModel").setProperty("/SameStore",`(${n}) ${i}`)}},onPressSaveMarketingDetails:function(){this._oBusyDialog.open+
();const e=this;const t=this.getOwnerComponent().plant;const i=this.getOwnerComponent().LegacyPropertyNumber;let n=this.byId("markKey").getValue();let s=this.byId("metroStats").getValue();let a=this.byId("neighbourwood").getValue();let r=this.byId("rankP+
rop").getSelectedKey();let l=this.byId("psCons").getValue();let u=this.byId("commType").getSelectedItem().getText();let g=true;if(n===""||n===undefined){this.model.setProperty("/MarketKey","Error")}else{this.model.setProperty("/MarketKey","None")}if(s===+
""||s===undefined){this.model.setProperty("/MetroStatisicalArea","Error")}else{this.model.setProperty("/MetroStatisicalArea","None")}if(a===""||a===undefined){this.model.setProperty("/Neighborwood","Error")}else{this.model.setProperty("/Neighborwood","No+
ne")}if(n===""||s===""||a===""||n===undefined||s===undefined||a===undefined||l===undefined){g=true}else{g=false}if(g===false){const g={MarketKey:n,MetroStatisicalArea:s,Neighborwood:a,SameStore:l,Rank:r,CommunityType:u};const d=`/PropertyMasterSet(Plant=+
'${t}',LegacyPropertyNumber='${i}')`;this._oModel.update(d,g,{success:function(t){e._oBusyDialog.close();e.getOwnerComponent.hasChanges=false;o.show("Saved Successfully")},error:function(t){e._oBusyDialog.close();o.show("Something went wrong with Service+
")}})}else{this._oBusyDialog.close();o.show("Please Fill all mandatory fields")}}})});                                                                                                                                                                         
//# sourceMappingURL=MarketingDetails.controller.js.map                                                                                                                                                                                                        