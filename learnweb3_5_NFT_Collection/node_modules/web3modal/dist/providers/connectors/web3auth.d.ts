import { IAbstractConnectorOptions } from "../../helpers";
export interface IWeb3AuthConnectorOptions extends IAbstractConnectorOptions {
    chainId?: number;
    clientId?: string;
    infuraId?: string;
}
declare const connectToweb3auth: (Web3Auth: any, opts: IWeb3AuthConnectorOptions) => Promise<unknown>;
export default connectToweb3auth;
//# sourceMappingURL=web3auth.d.ts.map