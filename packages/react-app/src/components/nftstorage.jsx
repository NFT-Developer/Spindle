import React, { useState } from 'react';
import { NFTStorage, File, Blob } from 'nft.storage'

const client = new NFTStorage({ token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDI4OTUxODgzNjZDYjRmZThFMEIyNGVkRDBCMzI4ZmM0RmFlZjQzMjciLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYyNTY3NTYzNTYzNSwibmFtZSI6ImZpbGVjb2luLXR1dCJ9.mz7T_l1nsaNhScLa2OR5UTrQxL6eUceu3L_1fNDJmA4' })

export default async function Nftstorage(props) { 
	const [cid, checkStatus] = useState(); 

	const status = await client.check(props.cid)
	console.log(status)

	// var val = await client.delete(cid)
	// console.log(val)


	// const status = await client.status(cid)

	// const metadata = await client.store({
	// 	name: '',
	// 	description: '',
	// 	image: new File(['<DATA>'], 'pinpie.jpg', { type: 'image/jpg'}),
	// 	properties: {
	// 		custom: 'custom data',
	// 		file: new File(['<DATA>'], 'README.md', { type: 'text/plain' }),
	// 	}
	// })

	// console.log('metdata URL:', metadata.url)
	// console.log('metdata.json:\n', metadata.data)
	// console.log('metdata.json with IPFS gateway URL:\n', metadata.embed())

}