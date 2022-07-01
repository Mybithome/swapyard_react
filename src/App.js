import { type } from '@testing-library/user-event/dist/type';
import './App.css';





function App() {
  return (
    
    <div className="main">

      <div className="header">
        <div className="logo">
          <img src='$logo' alt='SwapYard' />
        </div>
        <button className="enableEthereumButton">Enable Ethereum</button>
      </div>
      <div className="page">
        <div className="swaps_column">
          <div className="swaps_heading">
            SWAP
          </div>

          <div className='swaps'>
            
          </div>  

        </div>

        <div className='buys_column'>
          <div className='buys_heading'>
            BUY
          </div>

          <div className='buys'>
            
          </div>
          
        </div>

        <div className='sells_column'>
          <div className='sells_heading'>
            SELL
          </div>

          <div className='sells'>

          </div>

        </div>

        <div className='trade_column'>
          <div className='borrow_heading'>
              BORROW
          </div>

          <div className='borrow_select'>
              <div className='borrow_less'>
                  <img src='' alt=''></img>
              </div>
              <div className='borrow_amount'>
                10000
              </div>
              <div className='borrow_more'>
                  <img src='' alt=''></img>
              </div>
          </div>
            
          <div className='selected_cards'>
            <div className="swap_card">
            <div className="token_img">
                <img src='$logo' alt='$tokenName' />
            </div>
            <div className='details_left'>
                <div className='symbol'>
                "SYMBOL"
                </div>
                <div className='label'>
                "T" 987696
                </div>
            </div>
            <div className='details_right'>
                <div className='score'>
                3434
                </div>
                <div className='label'>
                VOLATILITY
                </div>
            </div>
            </div>
            <div className="buy_card">
            <div className="token_img">
                <img src='$logo' alt='$tokenName' />
            </div>
            <div className='details_left'>
                <div className='symbol'>
                "SYMBOL"
                </div>
                <div className='label'>
                "T" 987696
                </div>
            </div>
            <div className='details_right'>
                <div className='score'>
                + 3434
                </div>
                <div className='label'>
                VOLATILITY
                </div>
            </div>
            </div>
            <div className='swap_image'>
                <img src='' alt=''></img>
            </div>
            <div className="sell_card">
            <div className="token_img">
                <img src='$logo' alt='$tokenName' />
            </div>
            <div className='details_left'>
                <div className='symbol'>
                "SYMBOL"
                </div>
                <div className='label'>
                "T" 987696
                </div>
            </div>
            <div className='details_right'>
                <div className='score'>
                + 3434
                </div>
                <div className='label'>
                VOLATILITY
                </div>
            </div>
            </div>
          </div>
          <div className='trade_details reserves_delta'>
              <div className='label_left'>
                RERSERVE DELTA
              </div>
              <div className='label_right'>
                6546
              </div>
          </div>

          <div className='trade_details buy_return'>
              <div className='label_left'>
                BUY AMOUNT
              </div>
              <div className='label_right'>
                6546
              </div>
          </div>
          <div className='trade_details sell_return'>
              <div className='label_left'>
                SELL RETURN
              </div>
              <div className='label_right'>
                654156  
              </div>
          </div>
          <div className='trade_details estimated_return'>
              <div className='label_left'>
                EST RETURN
              </div>
              <div className='label_right'>
                235415   
              </div>
          </div>
          <div className='trade_details gas'>
              <div className='label_left'>
                EST GAS
              </div>
              <div className='label_right'>
                35
              </div>
          </div>
          {/* <div className='trade_details slippage'>
              <div className='label_left'>
                EST SLIPPAGE
              </div>
              <div className='label_right'>
                652%    
              </div>
          </div> */}
          
          <div className='test_button'>
              TEST
          </div>

          <div className='confirmation_button'>
              SEND
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
