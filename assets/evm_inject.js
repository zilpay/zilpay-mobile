(()=>{var{defineProperty:u,getOwnPropertyNames:f,getOwnPropertyDescriptor:b}=Object,w=Object.prototype.hasOwnProperty;var m=new WeakMap,P=(e)=>{var t=m.get(e),n;if(t)return t;if(t=u({},"__esModule",{value:!0}),e&&typeof e==="object"||typeof e==="function")f(e).map((r)=>!w.call(t,r)&&u(t,r,{get:()=>e[r],enumerable:!(n=b(e,r))||n.enumerable}));return m.set(e,t),t};var k=(e,t)=>{for(var n in t)u(e,n,{get:t[n],enumerable:!0,configurable:!0,set:(r)=>t[n]=()=>r})};var E={};k(E,{ZilPayProviderImpl:()=>v});function p(){let e=globalThis.document.querySelector("link[rel*=\'icon\']");if(!e)throw new Error("website favicon is required");return e.href}function y(){if(typeof document==="undefined")return{description:null,title:null,colors:null};let e=document.getElementsByTagName("meta"),t=null,n=null;for(let i=0;i<e.length;i++){let o=e[i],h=o.getAttribute("name"),g=o.getAttribute("content");if(!h||!g)continue;switch(h.toLowerCase()){case"description":t=g;break;case"title":n=g;break}}let r=window.getComputedStyle(document.body),a=document.querySelector("button"),s=a?window.getComputedStyle(a):null,c=a?window.getComputedStyle(a,":hover"):null,l={background:d(r.backgroundColor),text:d(r.color),primary:s?d(s.backgroundColor):void 0,secondary:c&&c.backgroundColor!==s?.backgroundColor?d(c.backgroundColor):s?d(s.backgroundColor):void 0};return{description:t,title:n,colors:l}}function d(e){let t=e.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);if(!t)return e;let n=parseInt(t[1]).toString(16).padStart(2,"0"),r=parseInt(t[2]).toString(16).padStart(2,"0"),a=parseInt(t[3]).toString(16).padStart(2,"0");return`#${n}${r}${a}`}class v{isZilPay=!0;supportedMethods=new Set(["eth_requestAccounts","eth_accounts","eth_sign","eth_sendTransaction","eth_getBalance","eth_getTransactionByHash","eth_getTransactionReceipt","eth_call","eth_estimateGas","eth_blockNumber","eth_getBlockByNumber","eth_getBlockByHash","eth_subscribe","eth_unsubscribe","net_version","eth_chainId","eth_getCode","eth_getStorageAt"]);#e=new Map;constructor(){this.#t(),this.#r()}#t(){this.#e.set("connect",new Set),this.#e.set("disconnect",new Set),this.#e.set("chainChanged",new Set),this.#e.set("accountsChanged",new Set),this.#e.set("message",new Set)}#r(){if(typeof window!=="undefined"&&window)window.handleZilPayEvent=(e)=>{let t=this.#e.get(e.event);if(t)switch(e.event){case"connect":t.forEach((r)=>r(e.data));break;case"disconnect":t.forEach((r)=>r(e.data));break;case"chainChanged":let n=e.data;if(typeof n!=="string"||!n.startsWith("0x")){console.warn("Invalid chainId format for chainChanged event");return}t.forEach((r)=>r(n));break;case"accountsChanged":t.forEach((r)=>r(e.data));break;case"message":t.forEach((r)=>r(e.data));break}}}async request(e){if(!this.supportedMethods.has(e.method))return Promise.reject({message:"Unsupported method",code:4200,data:{method:e.method}});let t=p();return new Promise((n,r)=>{let a=Math.random().toString(36).substring(2),s=y(),c={type:"ZILPAY_REQUEST",uuid:a,payload:e,icon:t,...s};if(typeof window==="undefined"||!window||!window.FlutterWebView){r({message:"ZilPay channel is not available",code:4900,data:null});return}try{window.FlutterWebView.postMessage(JSON.stringify(c))}catch(i){r({message:`Failed to send request: ${i.message}`,code:4000,data:i});return}let l=(i)=>{let o=i.data;if(o.type==="ZILPAY_RESPONSE"&&o.uuid===a){if(o.payload.error)r({message:o.payload.error.message,code:o.payload.error.code||4000,data:o.payload.error.data});else n(o.payload.result);window.removeEventListener("message",l)}};window.addEventListener("message",l)})}async enable(){return this.request({method:"eth_requestAccounts"})}on(e,t){let n=this.#e.get(e);if(n)n.add(t)}removeListener(e,t){let n=this.#e.get(e);if(n)n.delete(t)}}(function(){if(typeof window==="undefined"||!window){console.warn("No window object available for ZilPay injection");return}try{if("ethereum"in window&&window.ethereum){console.warn("Ethereum provider already exists in window");return}let e=new v;try{Object.defineProperty(window,"ethereum",{value:e,writable:!1,configurable:!0})}catch(t){window.ethereum=e,console.warn("Using fallback assignment for ethereum due to:",t)}window.dispatchEvent(new Event("ethereum#initialized")),console.log("Ethereum provider injected successfully")}catch(e){console.error("Failed to inject Ethereum provider:",e)}})();})();
