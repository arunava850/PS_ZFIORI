sap.ui.define(["sap/ui/model/json/JSONModel","sap/ui/Device"],function(e,t){"use strict";return{createDeviceModel:function(){var n=new e(t);n.setDefaultBindingMode("OneWay");return n},createModel:function(t){return new e(t)},createYearModel:function(){va+
r t=new e;t.loadData("model/yearbuilt.json");return t.getData()},createLFModel:function(){var t=new e;t.loadData("model/lfstatus.json");return t.getData()}}});                                                                                                
//# sourceMappingURL=models.js.map                                                                                                                                                                                                                             