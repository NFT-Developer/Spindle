pragma solidity 0.8.0;

interface ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId); 
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _approvedAddress, uint256 _tokenId) external;
    
    function balanceOf(address _owner) external view returns(uint256); 
    function ownerOf(uint256 _tokenId) external view returns(address);
    function getApproved(uint256 _tokenId) external view returns(address);
    
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);
}