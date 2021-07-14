pragma solidity 0.8.0;

import "./erc721.sol";
import "./erc721-token-receiver.sol";

contract NFTToken is ERC721 {
    // Mapping from NFT id to address owner
    mapping (uint256 => address) internal idToOwner;
    
    // Mapping from NFT id to approved address
    mapping (uint256 => address) internal idToApproval;
    
    // Mapping from address owner to count of their NFT tokens
    mapping (address => uint256) private ownerToNFTokenCount;
    
    // Mapping of owner address to mapping of operator address
    mapping (address => mapping (address => bool)) internal ownerToOperator;
    
    
    modifier canOperate(uint256 _tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner == msg.sender || ownerToOperator[tokenOwner][msg.sender], 'Not Owner');
        _;
    }
    
    modifier canTransfer(uint256 _tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner == msg.sender || idToApproval[_tokenId] == msg.sender || ownerToOperator[tokenOwner][msg.sender], 'Not owner approved');
        _;
    }
    
    // Check if NFT is valid
    modifier validNFToken(uint256 _tokenId) {
        require(idToOwner[_tokenId] != address(0), 'Not valid NFT');
        _;
    }
    
    // constructor() {
    //     supportedInterfaces
    // }
    
    
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external override {
        _safeTransferFrom(_from, _to, _tokenId, _data);
    }
    
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external override {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }
    
    function transferFrom(address _from, address _to, uint256 _tokenId) external override canTransfer(_tokenId) validNFToken(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner == _from, 'Not the NFT Owner');
        require(_to != address(0), 'Zero th address');
        
        _transfer(_to, _tokenId);
    }
    
    
    // 
    function approve(address _approved, uint256 _tokenId) external override canOperate(_tokenId) validNFToken(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(_approved != tokenOwner, 'Is owner');
        
        idToApproval[_tokenId] = _approved;
        emit Approval(tokenOwner, _approved, _tokenId);
    }
    
    function balanceOf(address _owner) external override view returns(uint256) {
        require(_owner != address(0), 'Zero address');
        return _getOwnerNFTCount(_owner);
    }
    
    function ownerOf(uint256 _tokenId) external override view returns(address _owner) {
        _owner = idToOwner[_tokenId];
        require(_owner != address(0), 'Not valid NFT');
    }
    
    function getApproved(uint256 _tokenId) external override view validNFToken(_tokenId) returns(address) {
        return idToApproval[_tokenId];
    }
    
    function isApprovedForAll(address _owner, address _operator) external override view returns(bool) {
        return ownerToOperator[_owner][_operator];
    }
    
    function _transfer(address _to, uint256 _tokenId) internal {
        address from = idToOwner[_tokenId];
        _clearApproval(_tokenId);
        
        _removeNFToken(from, _tokenId);
        _addNFToken(_to, _tokenId);
        
        emit Transfer(from, _to, _tokenId);
    }
    
    function _mint(address _to, uint256 _tokenId) internal virtual {
        require(_to != address(0), 'Zero Address');
        require(idToOwner[_tokenId] == address(0), 'Token already exists');
        
        _addNFToken(_to, _tokenId);
        
        emit Transfer(address(0), _to, _tokenId);
    }
    
    function _burn(uint256 _tokenId) internal virtual validNFToken(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        _clearApproval(_tokenId);
        _removeNFToken(tokenOwner, _tokenId);
        emit Transfer(tokenOwner, address(0), _tokenId);
    }
    
    function _removeNFToken(address _from, uint256 _tokenId) internal virtual {
        require(idToOwner[_tokenId] == _from, 'Not the NFT Owner');
        ownerToNFTokenCount[_from] -= 1;
        
        delete idToOwner[_tokenId];
    }
    
    function _addNFToken(address _to, uint256 _tokenId) internal virtual {
        require(idToOwner[_tokenId] == address(0), 'NFT already exists');
        
        idToOwner[_tokenId] = _to;
        ownerToNFTokenCount[_to] += 1;
    }
    
    function _getOwnerNFTCount(address _owner) internal virtual view returns(uint256) {
        return ownerToNFTokenCount[_owner];
    }
    
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) private canTransfer(_tokenId) validNFToken(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner == _from, 'Not the Owner');
        require(_to != address(0), 'Zero address');
        
        _transfer(_to, _tokenId);
        
        // if (_to.isContract()) {
        //     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        //     require(retval == )
        // }
    }
    
    function _clearApproval(uint256 _tokenId) private {
        delete idToApproval[_tokenId];
    }
}