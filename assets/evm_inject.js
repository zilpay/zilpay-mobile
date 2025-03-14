(()=>{var{defineProperty:N,getOwnPropertyNames:x,getOwnPropertyDescriptor:w}=Object,A=Object.prototype.hasOwnProperty;var j=new WeakMap,T=(e)=>{var n=j.get(e),r;if(n)return n;if(n=N({},"__esModule",{value:!0}),e&&typeof e==="object"||typeof e==="function")x(e).map((t)=>!A.call(n,t)&&N(n,t,{get:()=>e[t],enumerable:!(r=w(e,t))||r.enumerable}));return j.set(e,n),n};var L=(e,n)=>{for(var r in n)N(e,r,{get:n[r],enumerable:!0,configurable:!0,set:(t)=>n[r]=()=>t})};var m={};L(m,{ZilPayProviderImpl:()=>g});function l(){let e=globalThis.document.querySelector("link[rel*=\'icon\']");if(!e)throw new Error("website favicon is required");return e.href}function D(){if(typeof document==="undefined")return{description:null,title:null,colors:null};let e=document.getElementsByTagName("meta"),n=null,r=null;for(let i=0;i<e.length;i++){let o=e[i],I=o.getAttribute("name"),u=o.getAttribute("content");if(!I||!u)continue;switch(I.toLowerCase()){case"description":n=u;break;case"title":r=u;break}}let t=window.getComputedStyle(document.body),M=document.querySelector("button"),a=M?window.getComputedStyle(M):null,c=M?window.getComputedStyle(M,":hover"):null,s={background:d(t.backgroundColor),text:d(t.color),primary:a?d(a.backgroundColor):void 0,secondary:c&&c.backgroundColor!==a?.backgroundColor?d(c.backgroundColor):a?d(a.backgroundColor):void 0};return{description:n,title:r,colors:s}}function d(e){let n=e.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);if(!n)return e;let r=parseInt(n[1]).toString(16).padStart(2,"0"),t=parseInt(n[2]).toString(16).padStart(2,"0"),M=parseInt(n[3]).toString(16).padStart(2,"0");return`#${r}${t}${M}`}class g{isZilPay=!0;isBearby=!0;supportedMethods=new Set(["eth_requestAccounts","eth_accounts","eth_sendTransaction","eth_getBalance","eth_getTransactionByHash","eth_getTransactionReceipt","eth_call","eth_estimateGas","eth_blockNumber","eth_getBlockByNumber","eth_getBlockByHash","eth_subscribe","eth_unsubscribe","net_version","eth_chainId","eth_getCode","eth_getStorageAt","eth_gasPrice","eth_signTypedData","eth_signTypedData_v4","eth_getTransactionCount","personal_sign","eth_sign","wallet_addEthereumChain","wallet_switchEthereumChain","wallet_watchAsset","wallet_getPermissions","wallet_requestPermissions","wallet_scanQRCode","eth_getEncryptionPublicKey","eth_decrypt"]);#e=new Map;constructor(){this.#n(),this.#t()}#n(){this.#e.set("connect",new Set),this.#e.set("disconnect",new Set),this.#e.set("chainChanged",new Set),this.#e.set("accountsChanged",new Set),this.#e.set("message",new Set)}#t(){if(typeof window!=="undefined"&&window)window.handleZilPayEvent=(e)=>{let n=this.#e.get(e.event);if(n)switch(e.event){case"connect":n.forEach((t)=>t(e.data));break;case"disconnect":n.forEach((t)=>t(e.data));break;case"chainChanged":let r=e.data;if(typeof r!=="string"||!r.startsWith("0x")){console.warn("Invalid chainId format for chainChanged event");return}n.forEach((t)=>t(r));break;case"accountsChanged":n.forEach((t)=>t(e.data));break;case"message":n.forEach((t)=>t(e.data));break}}}async request(e){if(!this.supportedMethods.has(e.method))return Promise.reject({message:"Unsupported method",code:4200,data:{method:e.method}});let n=l();return new Promise((r,t)=>{let M=Math.random().toString(36).substring(2),a=D(),c={type:"ZILPAY_REQUEST",uuid:M,payload:e,icon:n,...a};if(typeof window==="undefined"||!window||!window.flutter_inappwebview){t({message:"ZilPay channel is not available",code:4900,data:null});return}let s=(i)=>{let o=i.data;if(!o||typeof o!=="object")return;if(o.type==="ZILPAY_RESPONSE"&&o.uuid===M){if(o.payload.error)t({message:o.payload.error.message,code:o.payload.error.code||4000,data:o.payload.error.data});else r(o.payload.result);window.removeEventListener("message",s)}};window.addEventListener("message",s);try{window.flutter_inappwebview.callHandler("EIP1193Channel",JSON.stringify(c)).catch((i)=>{window.removeEventListener("message",s),t({message:`Failed to send request: ${i.message||"Unknown error"}`,code:4000,data:i})})}catch(i){window.removeEventListener("message",s),t({message:`Failed to send request: ${i.message}`,code:4000,data:i})}})}async enable(){return this.request({method:"eth_requestAccounts"})}on(e,n){let r=this.#e.get(e);if(r)r.add(n)}removeListener(e,n){let r=this.#e.get(e);if(r)r.delete(n)}}function z(){if(typeof window!=="undefined"&&window.crypto&&typeof window.crypto.randomUUID==="function")return window.crypto.randomUUID();return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(e){let n=Math.random()*16|0;return(e==="x"?n:n&3|8).toString(16)})}function E(){return{uuid:z(),name:"ZilPay Wallet",icon:p(),rdns:"io.zilpay.wallet"}}function p(){return"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDUxMiA1MTIiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxwYXRoIGQ9Ik0yMzUuMzU4IDUxMS41NDNDMTUyLjIxIDUwMy4xMzQgNzYuNDczOCA0NTkuMTUyIDM1Ljg2NjQgMzk1LjQ0MkMxOS40MzAxIDM2OS41NyA2LjUzODg4IDMzNi41ODMgMi4zNDkyNCAzMDkuNzRDMC40NzIxNDMgMjkxLjA0NiAtMC4yODEyMDggMjcyLjI1NCAwLjA5MzI3NTYgMjUzLjQ2OUMyLjAyNjk2IDE5NS4yNTYgMTUuNTYyNyAxNTAuMzA0IDQyLjk1NjYgMTEwLjIwMkM1MS40MTggOTcuNjEwNyA2MS4zNzQzIDg2LjA5OTUgNzIuNjA2NCA3NS45MjE1Qzk0LjA3NDUgNTQuODk5MSAxMTkuMDU0IDM3LjgyMjkgMTQ2LjQwOSAyNS40NzA4QzE3MS4zNSAxMy40NzkgMTk3Ljk4MSA1LjQwNzQzIDIyNS4zNjcgMS41MzkxNUMyNDYuNjk3IC0wLjYxNTk5OCAyNjguMTk0IC0wLjUwNzYgMjg5LjUwMSAxLjg2MjU1QzMzOC40ODggOS4zMDA3NiAzODEuNjc0IDMwLjMyMTggNDIzLjI0OCA2Ni44NjYyQzQ2NC44MjIgMTAzLjQxMSA0OTYuNDA1IDE1MS45MjEgNTA3LjA0MSAxOTguNDlDNTExLjIzIDIxNS45NTQgNTExLjg3NSAyMjIuNzQ2IDUxMS44NzUgMjQ0LjQxM0M1MTIuNDY4IDI2MC4yODMgNTEwLjk1IDI3Ni4xNjIgNTA3LjM2MyAyOTEuNjNMNTA0Ljc4NSAzMDMuOTE5TDQ5NS43NjEgMzA1Ljg2QzQ2OS4yMTEgMzExLjA3NyA0NDMuMDQ1IDMxOC4xMDEgNDE3LjQ0NyAzMjYuODgxQzQwMS45NzcgMzMyLjcwMiAzOTguNzU0IDMzMy45OTUgMzc1Ljg3MiAzNDQuMDIxQzM1Mi45OTEgMzU0LjA0NiAzNDMuOTY3IDM1Ny42MDQgMzMyLjA0MiAzNjAuODM4QzMwNy4yMjcgMzY3LjYyOSAyODAuOCAzNjguMjc2IDI2My4wNzQgMzYyLjQ1NUMyMzguOTAzIDM1NC4zNyAyMjAuODU1IDMzNC45NjYgMjE2Ljk4OCAzMTMuMjk4QzIxNS43NTMgMzAzLjQ3MSAyMTYuMjk5IDI5My41IDIxOC42IDI4My44NjhDMjIzLjc1NiAyNjUuNDM0IDIzNS4wMzYgMjQ2LjM1NCAyNTIuNzYxIDIyNi42MjZMMjU4Ljg4NSAyMjAuMTU4QzI1OC44ODUgMjIwLjE1OCAyNjAuMTc0IDIyOC4yNDMgMjYxLjE0MSAyMzcuNjIyQzI2Mi4xMDcgMjQ3LjAwMSAyNjMuMzk3IDI1NS4wODYgMjYzLjM5NyAyNTUuNDA5TDI3MC40ODcgMjUzLjE0NUMyOTEuNzcxIDI0NS40NTIgMzE0Ljc5NyAyNDMuOTk0IDMzNi44NzcgMjQ4Ljk0MUMzNTQuMjg5IDI1My4yMDMgMzcxLjQwOSAyNTguNjA0IDM4OC4xMTkgMjY1LjExMUMzOTUuODU0IDI2OC4wMjIgNDA0LjIzMyAyNzAuOTMyIDQwNy4xMzQgMjcxLjU3OUM0MjQuMDYzIDI3My44NDQgNDQxLjI4NiAyNzEuNjEzIDQ1Ny4wODcgMjY1LjExMUM0NjAuOTU1IDI2My40OTQgNDYxLjI3NyAyNjMuMTcxIDQ2Mi4yNDQgMjU5LjI5QzQ2My41MzYgMjUwLjI4MSA0NjMuNTM2IDI0MS4xMzMgNDYyLjI0NCAyMzIuMTI0TDQ2MS4yNzcgMjI3LjI3M0w0NDUuNDg1IDIxNi42MDFDMzUxLjM3OSAxNTMuODYxIDI3Mi4wOTggMTE2LjM0NyAyMDUuMDY0IDEwMy40MTFDMTg2LjY5NCA5OS41Mjk3IDE1NC43ODggOTYuNjE5MSAxNTQuNzg4IDk4LjU1OTVDMTU0Ljc4OCAxMDAuNSAxNTQuNzg4IDk5Ljg1MzEgMTU0LjQ2NiAxMDAuMTc3QzE1NC4xNDMgMTAwLjUgMTYzLjQ5IDEwNS42NzQgMTg3Ljk4MyAxMTcuNjRMMjIxLjgyMiAxMzQuMTM0QzIxNy4wOTQgMTM2LjE0NCAyMTIuMjUyIDEzNy44NzIgMjA3LjMyIDEzOS4zMDhDMTg5LjAwMSAxNDUuMTMgMTcxLjEyMiAxNTIuMjY0IDE1My44MjEgMTYwLjY1M0MxNDAuOTMgMTY3LjEyMSAxMjIuMjM4IDE3Ny43OTMgMTIyLjIzOCAxNzkuMDg2TDEzNy43MDcgMTgxLjAyN0wxNTMuMTc3IDE4Mi4zMkwxNDQuNzk3IDE5MS4zNzZDMTMzLjE5NSAyMDMuMzQxIDEyNi43NSAyMTEuMTAzIDExMC4zMTMgMjMxLjE1NEw5Ni43Nzc0IDI0OC4yOTRIMTA4LjcwMkMxMTIuNjk2IDI0OC4yOTYgMTE2LjY4NCAyNDguNjIgMTIwLjYyNiAyNDkuMjY0QzEyMC42MjYgMjQ5LjU4OCAxMTUuMTQ3IDI2OC4wMjIgMTA4LjM4IDI5MC4zMzZDMTAxLjYxMiAzMTIuNjUxIDk2LjEzMjkgMzMxLjA4NSA5Ni40NTUyIDMzMS4wODVMMTA5LjAyNCAzMjguNDk4QzExNy40MDMgMzI2LjU1NyAxMjEuOTE1IDMyNS45MSAxMjIuMjM4IDMyNi41NTdDMTIyLjU2IDMyNy4yMDQgMTIzLjg0OSAzNDQuOTkxIDEyNS40NiAzNjYuNjU5QzEyNy4wNzIgMzg4LjMyNyAxMjguMDM5IDQwNi4xMTQgMTI4LjM2MSA0MDYuMTE0QzEzMi4yMjcgNDAzLjQ4NSAxMzUuODkgNDAwLjU2NCAxMzkuMzE4IDM5Ny4zODJMMTUwLjkyMSAzODguNjVDMTUxLjI0MyAzODguNjUgMTYwLjkxMSA0MDMuMjAzIDE3Mi44MzYgNDIwLjk5QzE4NC43NiA0MzguNzc3IDE5NC40MjggNDUzLjMzIDE5NC43NTEgNDUzLjMzQzE5OC41MTIgNDQ5Ljk4NiAyMDEuOTY0IDQ0Ni4zMDYgMjA1LjA2NCA0NDIuMzM1QzIxMi43OTggNDMzLjI4IDIxNS4wNTQgNDMxLjAxNiAyMTUuNjk5IDQzMS45ODZMMjI0LjcyMyA0NDIuNjU4QzIyOC45MTMgNDQ3LjgzMyAyMzYuNjQ3IDQ1Ni4yNDEgMjQxLjgwNCA0NjEuNDE1TDI1MC44MjggNDcwLjQ3MUgyNzAuMTY0QzMwMC43ODEgNDcwLjQ3MSAzMTkuNzk2IDQ3My4zODEgMzQ1LjI1NiA0ODIuNzZMMzUyLjk5MSA0ODUuMzQ3TDM1MC40MTIgNDg3LjI4OEMzMzUuMjY1IDQ5OC42MDcgMzE1LjYwNiA1MDYuMDQ1IDI5MS4xMTMgNTA5LjkyNkMyODEuMjgzIDUxMS4yMjYgMjcxLjM3OCA1MTEuODc2IDI2MS40NjMgNTExLjg2NkMyNTAuODI4IDUxMi4xODkgMjM4LjkwMyA1MTEuODY2IDIzNS4zNTggNTExLjU0M1oiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcl85N18xNzcpIi8+CjxkZWZzPgo8bGluZWFyR3JhZGllbnQgaWQ9InBhaW50MF9saW5lYXJfOTdfMTc3IiB4MT0iMTAxLjUzMyIgeTE9IjU1LjU0MDYiIHgyPSIzMjEuODQiIHkyPSI0OTQuNjI5IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIG9mZnNldD0iMC4wMDUiIHN0b3AtY29sb3I9IiMyOUNDQzQiLz4KPHN0b3Agb2Zmc2V0PSIwLjU5NSIgc3RvcC1jb2xvcj0iI0RGMDFCOCIvPgo8c3RvcCBvZmZzZXQ9IjAuODExNDU5IiBzdG9wLWNvbG9yPSIjRUYzQzhFIi8+CjxzdG9wIG9mZnNldD0iMSIvPgo8L2xpbmVhckdyYWRpZW50Pgo8L2RlZnM+Cjwvc3ZnPgo="}function y(e){if(typeof window==="undefined")return;let r={info:E(),provider:e},t=new CustomEvent("eip6963:announceProvider",{detail:Object.freeze(r)});window.dispatchEvent(t)}function v(e){if(typeof window==="undefined")return;window.addEventListener("eip6963:requestProvider",()=>{y(e)})}(function(){if(typeof window==="undefined"||!window){console.warn("No window object available for ZilPay injection");return}try{let e=new g;if(!("ethereum"in window)||!window.ethereum)try{Object.defineProperty(window,"ethereum",{value:e,writable:!1,configurable:!0})}catch(n){window.ethereum=e,console.warn("Using fallback assignment for ethereum due to:",n)}y(e),v(e),window.__zilpay_response_handlers=window.__zilpay_response_handlers||{},window.dispatchEvent(new Event("ethereum#initialized"))}catch(e){console.error("Failed to inject Ethereum provider:",e)}})();})();
