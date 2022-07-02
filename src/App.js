import { type } from '@testing-library/user-event/dist/type';
import './App.css';





function App() {
  return (
    
    <div className="main">

      <div className="header">
        <div className="logo">
          S|Y
        </div>
        <button className="enableEthereumButton ui-btn ui-shadow ui-corner-all" data-role="button">Connect To Wallet</button>
      </div>
      <div className="page">
        <div className="swaps_column">
          <div className="swaps_heading">
            First choose a coin to swap...
          </div>

          <div className='swaps'>
            
          </div>  

        </div>

        <div className='buys_column'>
          <div className='buys_heading'>
            Now choose where to buy... 
          </div>

          <div className='buys'>
            
          </div>
          
        </div>

        <div className='sells_column'>
          <div className='sells_heading'>
            Next choose a place to sell...
          </div>

          <div className='sells'>

          </div>

        </div>

        <div className='trade_column'>
          <div className='borrow_heading'>
              Borrow money and trade...
          </div>

          <div className='borrow_select'>
              <div className='borrow_amount'>
                $10000
              </div>
              <input type="range" name="slider-1" id="slider-1" min="0" step="1000" max="10000" ></input>
          </div>
            
          <div className='selected_cards'>
            <div className="swap_card">
              No Coin Selected...
            </div>
            <div className="buy_card">
              No Buy Exchange Selected...
            </div>
            <div className="sell_card">
              No Sell Exchange Selected...
            </div>
          </div>
          <div className='trade_details reserves_delta'>
              <div className='label_left'>
                RERSERVE DELTA
              </div>
              <div className='label_right'>
                000
              </div>
          </div>

          <div className='trade_details buy_return'>
              <div className='label_left'>
                BUY AMOUNT
              </div>
              <div className='label_right'>
                000
              </div>
          </div>
          <div className='trade_details sell_return'>
              <div className='label_left'>
                SELL RETURN
              </div>
              <div className='label_right'>
                000
              </div>
          </div>
          <div className='trade_details estimated_return'>
              <div className='label_left'>
                EST RETURN
              </div>
              <div className='label_right'>
                000   
              </div>
          </div>
          <div className='trade_details gas'>
              <div className='label_left'>
                EST GAS
              </div>
              <div className='label_right'>
                000
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
