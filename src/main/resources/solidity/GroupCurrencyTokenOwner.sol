
// File: interfaces/HubI.sol


pragma solidity ^0.7.0;

interface HubI {
    function issuance() external view returns (uint256);
    function issuanceByStep(uint256) external view returns (uint256);
    function inflation() external view returns (uint256);
    function divisor() external view returns (uint256);
    function period() external view returns (uint256);
    function periods() external view returns (uint256);
    function signupBonus() external view returns (uint256);
    function pow(uint256, uint256) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function deployedAt() external view returns (uint256);
    function inflate(uint256, uint256) external view returns (uint256);
    function timeout() external view returns (uint256);
    function userToToken(address) external returns (address);
    function tokenToUser(address) external returns (address);
    function limits(address,address) external returns (uint256);
}

// File: lib/Address.sol



pragma solidity ^0.7.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
// File: lib/SafeMath.sol



pragma solidity ^0.7.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}
// File: ERC20.sol


// Based on @openzeppelin/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.7.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */

contract ERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external virtual view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() external virtual view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: Token.sol


pragma solidity ^0.7.0;




contract Token is ERC20 {
    using SafeMath for uint256;

    uint8 public immutable override decimals = 18;

    uint256 public lastTouched; // the timestamp of the last ubi payout
    address public hub; // the address of the hub this token was deployed through
    address public immutable owner; // the safe that deployed this token
    uint256 public inflationOffset; // the amount of seconds until the next inflation step
    uint256 public currentIssuance; // issanceRate at the time this token was deployed
    bool private manuallyStopped; // true if this token has been stopped by it's owner

    /// @dev modifier allowing function to be only called through the hub
    modifier onlyHub() {
        require(msg.sender == hub);
        _;
    }

    /// @dev modifier allowing function to be only called by the token owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _owner) {
        require(_owner != address(0));
        owner = _owner;
        hub = msg.sender;
        lastTouched = time();
        inflationOffset = findInflationOffset();
        currentIssuance = HubI(hub).issuance();
        _mint(_owner, HubI(hub).signupBonus());
    }

    /// @notice helper function for block timestamp
    /// @return the block timestamp
    function time() public view returns (uint256) {
        return block.timestamp;
    }

    /// @notice helper function for the token symbol
    /// @dev all circles tokens should have the same symbol
    /// @return the token symbol
    function symbol() public view override returns (string memory) {
        return HubI(hub).symbol();
    }

    /// @notice helper function for the token name
    /// @dev all circles tokens should have the same name
    /// @return the token name
    function name() public view returns (string memory) {
        return HubI(hub).name();
    }

    /// @notice helper function for fetching the period length from the hub
    /// @return period length in seconds
    function period() public view returns (uint256) {
        return HubI(hub).period();
    }

    /// @notice helper function for fetching the number of periods from the hub
    /// @return the number of periods since the hub was deployed
    function periods() public view returns (uint256) {
        return HubI(hub).periods();
    }

    /// @notice helper function for fetching the timeout from the hub
    /// @return the number of seconds the token can go without being updated before it's deactivated
    function timeout() public view returns (uint256) {
        return HubI(hub).timeout();
    }

    /// @notice find the inflation step when ubi was last payed out
    /// @dev ie. if ubi was last payed out during the second inflation step, returns two
    /// @return the inflation step by count
    function periodsWhenLastTouched() public view returns (uint256) {
        return (lastTouched.sub(hubDeployedAt())).div(period());
    }

    /// @notice helper functio for getting the hub deployment time
    /// @return the timestamp the hub was deployed at
    function hubDeployedAt() public view returns (uint256) {
        return HubI(hub).deployedAt();
    }

    /// @notice Caution! manually deactivates or stops this token, no ubi will be payed out after this is called
    /// @dev intended for use in case of key loss, system failure, or migration to new contracts
    function stop() public onlyOwner {
        manuallyStopped = true;
    }

    /// @notice checks whether this token has been either stopped manually, or whether it has timed out
    /// @dev combines the manual stop variable with a dead man's switch
    /// @return false is the token is still paying out ubi, otherwise true
    function stopped() public view returns (bool) {
        if (manuallyStopped) return true;
        uint256 secondsSinceLastTouched = time().sub(lastTouched);
        if (secondsSinceLastTouched > timeout()) return true;
        return false;
    }

    /// @notice the amount of seconds until the ubi payout is next inflated
    /// @dev ubi is payed out continuously between inflation steps
    /// @return the amount of seconds until the next inflation step
    function findInflationOffset() public view returns (uint256) {
        // finds the timestamp of the next inflation step, and subtracts the current timestamp
        uint256 nextInflation =
        ((period().mul(periods().add(1))).add(hubDeployedAt()));
        return nextInflation.sub(time());
    }

    /// @notice checks how much ubi this token holder is owed, but doesn't update their balance
    /// @dev is called in the update method to write the new balance to state, but also useful in wallets
    /// @return how much ubi this token holder is owed
    function look() public view returns (uint256) {
        // don't payout ubi if the token has been deactivated/stopped
        if (stopped()) return 0;
        uint256 payout = 0;
        uint256 clock = lastTouched;
        uint256 offset = inflationOffset;
        uint256 rate = currentIssuance;
        uint256 p = periodsWhenLastTouched();
        // this while loop gets executed only when we're rolling over an inflation step
        // in the course of a ubi payout aka while we have to pay out ubi for more time
        // than lastTouched + inflationOffset
        while (clock.add(offset) <= time()) {
            // add the remaining offset time to the payout total at the current rate
            payout = payout.add(offset.mul(rate));
            // adjust clock to the timestamp of the next inflation step
            clock = clock.add(offset);
            // the offset is now the length of 1 period
            offset = period();
            // increment the period we are paying out for
            p = p.add(1);
            // find the issuance rate as of the next period
            rate = HubI(hub).issuanceByStep(p);
        }
        // at this point, time() - clock should always be less than 1 period
        uint256 timeSinceLastPayout = time().sub(clock);
        payout = payout.add(timeSinceLastPayout.mul(rate));
        return payout;
    }

    /// @notice receive a ubi payout
    /// @dev this is the method to actually update storage with new token balance
    function update() public {
        uint256 gift = look();
        // does nothing if there's no ubi to be payed out
        if (gift > 0) {
            // update the state variables used to calculate ubi, then mint
            inflationOffset = findInflationOffset();
            lastTouched = time();
            currentIssuance = HubI(hub).issuance();
            _mint(owner, gift);
        }
    }

    /// @notice special method called by the hub to execute a transitive transaction
    /// @param from the address the tokens are being transfered from
    /// @param to the address the tokens are being transferred to
    /// @param amount the amount of tokens to transfer
    function hubTransfer(
        address from,
        address to,
        uint256 amount
    ) public onlyHub returns (bool) {
        _transfer(from, to, amount);
    }

    function transfer(address dst, uint256 wad) public override returns (bool) {
        // this code shouldn't be necessary, but when it's removed the gas estimation methods
        // in the gnosis safe no longer work, still true as of solidity 7.1
        return super.transfer(dst, wad);
    }
}

// File: OrgaHub.sol


pragma solidity ^0.7.0;



contract OrgaHub {
    using SafeMath for uint256;

    address public admin;
    uint256 public immutable inflation; // the inflation rate expressed as 1 + percentage inflation, aka 7% inflation is 107
    uint256 public immutable divisor; // the largest power of 10 the inflation rate can be divided by
    uint256 public immutable period; // the amount of sections between inflation steps
    string public symbol;
    string public name;
    uint256 public immutable signupBonus; // a one-time payout made immediately on signup
    uint256 public immutable initialIssuance; // the starting payout per second, this gets inflated by the inflation rate
    uint256 public immutable deployedAt; // the timestamp this contract was deployed at
    uint256 public immutable timeout; // longest a token can go without a ubi payout before it gets deactivated

    mapping (address => Token) public userToToken;
    mapping (address => address) public tokenToUser;
    mapping (address => bool) public organizations;
    mapping (address => mapping (address => uint256)) public limits;

    event Signup(address indexed user, address token);
    event OrganizationSignup(address indexed organization);
    event Trust(address indexed canSendTo, address indexed user, uint256 limit);
    event HubTransfer(address indexed from, address indexed to, uint256 amount);

    // some data types used for validating transitive transfers
    struct transferValidator {
        bool seen;
        uint256 sent;
        uint256 received;
    }
    mapping (address => transferValidator) public validation;
    address[] public seen;

    constructor(
        address _admin,
        uint256 _inflation,
        uint256 _period,
        string memory _symbol,
        string memory _name,
        uint256 _signupBonus,
        uint256 _initialIssuance,
        uint256 _timeout
    ) {
        admin = _admin;
        inflation = _inflation;
        divisor = findDivisor(_inflation);
        period = _period;
        symbol = _symbol;
        name = _name;
        signupBonus = _signupBonus;
        initialIssuance = _initialIssuance;
        deployedAt = block.timestamp;
        timeout = _timeout;
    }

    function changeAdmin(address _admin) public {
        require(msg.sender == admin, "Only Admin can change admin.");
        admin = _admin;
    }

    /// @notice calculates the correct divisor for the given inflation rate
    /// @dev the divisor is used to maintain precision when doing math with percentages
    /// @param _inf the inflation rate
    /// @return the largest power of ten the inflation rate can be divided by
    function findDivisor(uint256 _inf) internal pure returns (uint256) {
        uint256 iter = 0;
        while (_inf.div(pow(10, iter)) > 9) {
            iter += 1;
        }
        return pow(10, iter);
    }

    /// @notice helper function for finding the amount of inflation periods since this hub was deployed
    /// @return the amount of periods since hub was deployed
    function periods() public view returns (uint256) {
        return (block.timestamp.sub(deployedAt)).div(period);
    }

    /// @notice calculates the current issuance rate per second
    /// @dev current issuance is the initial issuance inflated by the amount of inflation periods since the hub was deployed
    /// @return current issuance rate
    function issuance() public view returns (uint256) {
        return inflate(initialIssuance, periods());
    }

    /// @notice finds the inflation rate at a given inflation period
    /// @param _periods the step to calculate the issuance rate at
    /// @return inflation rate as of the given period
    function issuanceByStep(uint256 _periods) public view returns (uint256) {
        return inflate(initialIssuance, _periods);
    }

    /// @notice find the current issuance rate for any initial issuance and amount of periods
    /// @dev this is basically the calculation for compound interest, with some adjustments because of integer math
    /// @param _initial the starting issuance rate
    /// @param _periods the step to calculate the issuance rate as of
    /// @return initial issuance rate as if interest (inflation) has been compounded period times
    function inflate(uint256 _initial, uint256 _periods) public view returns (uint256) {
        // this returns P * (1 + r) ** t - which is a the formula for compound interest if
        // interest is compounded only once per period
        // in our case, currentIssuanceRate = initialIssuance * (inflation) ** periods
        uint256 q = pow(inflation, _periods);
        uint256 d = pow(divisor, _periods);
        return (_initial.mul(q)).div(d);
    }

    /// @notice signup to this circles hub - create a circles token and join the trust graph
    /// @dev signup is permanent, there's no way to unsignup
    function signup() public {
        // signup can only be called once
        require(address(userToToken[msg.sender]) == address(0), "You can't sign up twice");
        // organizations cannot sign up for a token
        require(organizations[msg.sender] == false, "Organizations cannot signup as normal users");

        Token token = new Token(msg.sender);
        userToToken[msg.sender] = token;
        tokenToUser[address(token)] = msg.sender;
        // every user must trust themselves with a weight of 100
        // this is so that all users accept their own token at all times
        _trust(msg.sender, 100);

        emit Signup(msg.sender, address(token));
    }

    /// @notice register an organization address with the hub and join the trust graph
    /// @dev signup is permanent for organizations too, there's no way to unsignup
    function organizationSignup() public {
        // can't register as an organization if you have a token
        require(address(userToToken[msg.sender]) == address(0), "Normal users cannot signup as organizations");
        // can't register as an organization twice
        require(organizations[msg.sender] == false, "You can't sign up as an organization twice");

        organizations[msg.sender] = true;

        emit OrganizationSignup(msg.sender);
    }

    /// @notice trust a user, calling this means you're able to receive tokens from this user transitively
    /// @dev the trust graph is weighted and directed
    /// @param user the user to be trusted
    /// @param limit the amount this user is trusted, as a percentage of 100
    function trust(address user, uint limit) public {
        // only users who have signed up as tokens or organizations can enter the trust graph
        require(address(userToToken[msg.sender]) != address(0) || organizations[msg.sender], "You can only trust people after you've signed up!");
        // you must continue to trust yourself 100%
        require(msg.sender != user, "You can't untrust yourself");
        // organizations can't receive trust since they don't have their own token (ie. there's nothing to trust)
        require(organizations[user] == false, "You can't trust an organization");
        // must a percentage
        require(limit <= 100, "Limit must be a percentage out of 100");
        // organizations don't have a token to base send limits off of, so they can only trust at rates 0 or 100
        if (organizations[msg.sender]) {
            require(limit == 0 || limit == 100, "Trust is binary for organizations");
        }
        _trust(user, limit);
    }

    /// @dev used internally in both the trust function and signup
    /// @param user the user to be trusted
    /// @param limit the amount this user is trusted, as a percentage of 100
    function _trust(address user, uint limit) internal {
        limits[msg.sender][user] = limit;
        emit Trust(msg.sender, user, limit);
    }

    /// @dev this is an implementation of exponentiation by squares
    /// @param base the base to be used in the calculation
    /// @param exponent the exponent to be used in the calculation
    /// @return the result of the calculation
    function pow(uint256 base, uint256 exponent) public pure returns (uint256) {
        if (base == 0) {
            return 0;
        }
        if (exponent == 0) {
            return 1;
        }
        if (exponent == 1) {
            return base;
        }
        uint256 y = 1;
        while(exponent > 1) {
            if(exponent.mod(2) == 0) {
                base = base.mul(base);
                exponent = exponent.div(2);
            } else {
                y = base.mul(y);
                base = base.mul(base);
                exponent = (exponent.sub(1)).div(2);
            }
        }
        return base.mul(y);
    }

    /// @notice finds the maximum amount of a specific token that can be sent between two users
    /// @dev the goal of this function is to always return a sensible number, it's used to validate transfer throughs, and also heavily in the graph/pathfinding services
    /// @param tokenOwner the safe/owner that the token was minted to
    /// @param src the sender of the tokens
    /// @param dest the recipient of the tokens
    /// @return the amount of tokenowner's token src can send to dest
    function checkSendLimit(address tokenOwner, address src, address dest) public view returns (uint256) {

        // there is no trust
        if (limits[dest][tokenOwner] == 0) {
            return 0;
        }

        // if dest hasn't signed up, they cannot trust anyone
        if (address(userToToken[dest]) == address(0) && !organizations[dest] ) {
            return 0;
        }

        //if the token doesn't exist, it can't be sent/accepted
        if (address(userToToken[tokenOwner]) == address(0)) {
            return 0;
        }

        uint256 srcBalance = userToToken[tokenOwner].balanceOf(src);

        // if sending dest's token to dest, src can send 100% of their holdings
        // for organizations, trust is binary - if trust is not 0, src can send 100% of their holdings
        if (tokenOwner == dest || organizations[dest]) {
            return srcBalance;
        }

        // find the amount dest already has of the token that's being sent
        uint256 destBalance = userToToken[tokenOwner].balanceOf(dest);

        uint256 oneHundred = 100;

        // find the maximum possible amount based on dest's trust limit for this token
        uint256 max = (userToToken[dest].balanceOf(dest).mul(limits[dest][tokenOwner])).div(oneHundred);

        // if trustLimit has already been overriden by a direct transfer, nothing more can be sent
        if (max < destBalance) return 0;

        uint256 destBalanceScaled = destBalance.mul(oneHundred.sub(limits[dest][tokenOwner])).div(oneHundred);

        // return the max amount dest is willing to hold minus the amount they already have
        return max.sub(destBalanceScaled);
    }

    /// @dev builds the validation data structures, called for each transaction step of a transtive transactions
    /// @param src the sender of a single transaction step
    /// @param dest the recipient of a single transaction step
    /// @param wad the amount being passed along a single transaction step
    function buildValidationData(address src, address dest, uint wad) internal {
        // the validation mapping has this format
        // { address: {
        //     seen: whether this user is part of the transaction,
        //     sent: total amount sent by this user,
        //     received: total amount received by this user,
        //    }
        // }
        if (validation[src].seen != false) {
            // if we have seen the addresses, increment their sent amounts
            validation[src].sent = validation[src].sent.add(wad);
        } else {
            // if we haven't, add them to the validation mapping
            validation[src].seen = true;
            validation[src].sent = wad;
            seen.push(src);
        }
        if (validation[dest].seen != false) {
            // if we have seen the addresses, increment their sent amounts
            validation[dest].received = validation[dest].received.add(wad);
        } else {
            // if we haven't, add them to the validation mapping
            validation[dest].seen = true;
            validation[dest].received = wad;
            seen.push(dest);
        }
    }

    /// @dev performs the validation for an attempted transitive transfer
    /// @param steps the number of steps in the transitive transaction
    function validateTransferThrough(uint256 steps) internal {
        // a valid path has only one real sender and receiver
        address src;
        address dest;
        // iterate through the array of all the addresses that were part of the transaction data
        for (uint i = 0; i < seen.length; i++) {
            transferValidator memory curr = validation[seen[i]];
            // if the address sent more than they received, they are the sender
            if (curr.sent > curr.received) {
                // if we've already found a sender, transaction is invalid
                require(src == address(0), "Path sends from more than one src");
                // the real token sender must also be the transaction sender
                if (msg.sender == admin) {
                    // WARN: we remove this check here to allow for require(seen[i] == msg.sender, "Path doesn't send from transaction sender");
                } else {
                    require(seen[i] == msg.sender, "Path doesn't send from transaction sender");
                }
                src = seen[i];
            }
            // if the address received more than they sent, they are the recipient
            if (curr.received > curr.sent) {
                // if we've already found a recipient, transaction is invalid
                require(dest == address(0), "Path sends to more than one dest");
                dest = seen[i];
            }
        }
        // a valid path has both a sender and a recipient
        require(src != address(0), "Transaction must have a src");
        require(dest != address(0), "Transaction must have a dest");
        // sender should not recieve, recipient should not send
        // by this point in the code, we should have one src and one dest and no one else's balance should change
        require(validation[src].received == 0, "Sender is receiving");
        require(validation[dest].sent == 0, "Recipient is sending");
        // the total amounts sent and received by sender and recipient should match
        require(validation[src].sent == validation[dest].received, "Unequal sent and received amounts");
        // the maximum amount of addresses we should see is one more than steps in the path
        require(seen.length <= steps + 1, "Seen too many addresses");
        emit HubTransfer(src, dest, validation[src].sent);
        // clean up the validation datastructures
        for (uint i = seen.length; i >= 1; i--) {
            delete validation[seen[i-1]];
        }
        delete seen;
        // sanity check that we cleaned everything up correctly
        require(seen.length == 0, "Seen should be empty");
    }

    /// @notice walks through tokenOwners, srcs, dests, and amounts array and executes transtive transfer
    /// @dev tokenOwners[0], srcs[0], dests[0], and wads[0] constitute a transaction step
    /// @param tokenOwners the owner of the tokens being sent in each transaction step
    /// @param srcs the sender of each transaction step
    /// @param dests the recipient of each transaction step
    /// @param wads the amount for each transaction step
    function transferThrough(
        address[] memory tokenOwners,
        address[] memory srcs,
        address[] memory dests,
        uint[] memory wads
    ) public {
        // all the arrays must be the same length
        require(dests.length == tokenOwners.length, "Tokens array length must equal dests array");
        require(srcs.length == tokenOwners.length, "Tokens array length must equal srcs array");
        require(wads.length == tokenOwners.length, "Tokens array length must equal amounts array");
        for (uint i = 0; i < srcs.length; i++) {
            address src = srcs[i];
            address dest = dests[i];
            address token = tokenOwners[i];
            uint256 wad = wads[i];

            // check that no trust limits are violated
            uint256 max = checkSendLimit(token, src, dest);
            require(wad <= max, "Trust limit exceeded");

            buildValidationData(src, dest, wad);

            // go ahead and do the transfers now so that we don't have to walk through this array again
            userToToken[token].hubTransfer(src, dest, wad);
        }
        // this will revert if there are any problems found
        validateTransferThrough(srcs.length);
    }
}


// File: GroupCurrencyToken.sol


pragma solidity ^0.7.0;




contract GroupCurrencyToken is ERC20 {
    using SafeMath for uint256;

    uint8 public immutable override decimals = 18;
    uint8 public mintFeePerThousand;

    bool public suspended;

    string public name;
    string public override symbol;

    address public owner; // the safe/EOA/contract that deployed this token, can be changed by owner
    address public hub; // the address of the hub this token is associated with
    address public treasury; // account which gets the personal tokens for whatever later usage

    mapping (address => bool) public directMembers;
    mapping (address => bool) public delegatedTrustees;

    event Minted(address indexed receiver, uint256 amount, uint256 mintAmount, uint256 mintFee);

    /// @dev modifier allowing function to be only called by the token owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _hub, address _treasury, address _owner, uint8 _mintFeePerThousand, string memory _name, string memory _symbol) {
        symbol = _symbol;
        name = _name;
        owner = _owner;
        hub = _hub;
        treasury = _treasury;
        mintFeePerThousand = _mintFeePerThousand;
    }

    function suspend(bool _suspend) public onlyOwner {
        suspended = _suspend;
    }

    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function addMemberToken(address _member) public onlyOwner {
        directMembers[_member] = true;
    }

    function removeMemberToken(address _member) public onlyOwner {
        directMembers[_member] = false;
    }

    function addDelegatedTrustee(address _account) public onlyOwner {
        delegatedTrustees[_account] = true;
    }

    function removeDelegatedTrustee(address _account) public onlyOwner {
        delegatedTrustees[_account] = false;
    }

    // Group currently is created from collateral tokens. Collateral is directly part of the directMembers dictionary.
    function mint(address _collateral, uint256 _amount) public returns (uint256) {
        require(!suspended, "Minting has been suspended.");
        require(directMembers[_collateral], "Collateral address is not marked as direct member.");
        return transferCollateralAndMint(_collateral, _amount);
    }

    // Group currently is created from collateral tokens. Collateral is trusted by someone in the delegatedTrustees dictionary.
    function mintDelegate(address _trustedBy, address _collateral, uint256 _amount) public returns (uint256) {
        require(!suspended, "Minting has been suspended.");
        require(_trustedBy != address(0), "trustedBy must be valid address.");
        // require(trusted_by in delegated_trustees)
        require(delegatedTrustees[_trustedBy], "trustedBy not contained in delegatedTrustees.");
        address collateralOwner = HubI(hub).tokenToUser(_collateral);
        // require(trusted_by.trust(collateral)
        require(HubI(hub).limits(_trustedBy, collateralOwner) > 0, "trustedBy does not trust collateral owner.");
        return transferCollateralAndMint(_collateral, _amount);
    }

    function transferCollateralAndMint(address _collateral, uint256 _amount) internal returns (uint256) {
        uint256 mintFee = (_amount.div(1000)).mul(mintFeePerThousand);
        uint256 mintAmount = _amount.sub(mintFee);
        // mint amount-fee to msg.sender
        _mint(msg.sender, mintAmount);
        // Token Swap
        ERC20(_collateral).transferFrom(msg.sender, treasury, _amount);
        emit Minted(msg.sender, _amount, mintAmount, mintFee);
        return mintAmount;
    }

    function transfer(address dst, uint256 wad) public override returns (bool) {
        // this code shouldn't be necessary, but when it's removed the gas estimation methods
        // in the gnosis safe no longer work, still true as of solidity 7.1
        return super.transfer(dst, wad);
    }
}

// File: GroupCurrencyTokenOwner.sol


pragma solidity ^0.7.0;




contract GroupCurrencyTokenOwner {
    using SafeMath for uint256;

    address public token; // the safe/EOA/contract that deployed this token, can be changed by owner
    address public hub; // the address of the hub this token is associated with
    address public owner;

    event Minted(address indexed receiver, address indexed collateral, uint256 amount);

    /// @dev modifier allowing function to be only called by the token owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _hub, address _token, address _owner) {
        owner = _owner;
        hub = _hub;
        token = _token;
    }

    function setup() public onlyOwner {
        OrgaHub(hub).organizationSignup();
        GroupCurrencyToken(token).addDelegatedTrustee(address(this));
    }

    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    // Group currently is created from collateral tokens. Collateral is directly part of the directMembers dictionary.
    function mintTransitive(address[] memory tokenOwners, address[] memory srcs, address[] memory dests, uint[] memory wads) public {
        require(tokenOwners[0] == msg.sender, "First token owner must be message sender.");
        uint lastElementIndex = tokenOwners.length-1;
        require(dests[lastElementIndex] == address(this), "GroupCurrencyTokenOwner must be final receiver in the path.");
        OrgaHub(hub).transferThrough(tokenOwners, srcs, dests, wads);
        ERC20(HubI(hub).userToToken(tokenOwners[lastElementIndex])).approve(token, wads[lastElementIndex]);
        uint mintedAmount = GroupCurrencyToken(token).mintDelegate(address(this), HubI(hub).userToToken(tokenOwners[lastElementIndex]), wads[lastElementIndex]);
        GroupCurrencyToken(token).transfer(srcs[0], mintedAmount);
    }

    // Trust must be called by this contract (as a delegate) on Hub
    function trust(address _trustee) public onlyOwner {
        OrgaHub(hub).trust(_trustee, 100);
    }

}