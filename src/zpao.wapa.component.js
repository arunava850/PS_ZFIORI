sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","com/public/storage/pao/model/models"],function(e,t,s){"use strict";return e.extend("com.public.storage.pao.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init.apply(this,argume+
nts);this.getRouter().initialize();this.setModel(s.createDeviceModel(),"device");const t=this.getModel("mainModel");sap.ui.getCore().setModel(t,"mainModel");sap.ui.getCore().setModel(s.createYearModel(),"yearModel");sap.ui.getCore().setModel(s.createLFMo+
del(),"LFModel");var o=jQuery.sap.getModulePath("com.public.storage.pao");var i=new sap.ui.model.json.JSONModel({path:o});this.setModel(i,"imageModel")},getContentDensityClass:function(){if(this._sContentDensityClass===undefined){if(document.body.classLi+
st.contains("sapUiSizeCozy")||document.body.classList.contains("sapUiSizeCompact")){this._sContentDensityClass=""}else if(!t.support.touch){this._sContentDensityClass="sapUiSizeCompact"}else{this._sContentDensityClass="sapUiSizeCozy"}}return this._sConte+
ntDensityClass}})});                                                                                                                                                                                                                                           
//# sourceMappingURL=Component.js.map                                                                                                                                                                                                                          