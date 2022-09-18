Project: Trustless Cash Management

Specification:
1. Contract is able to manage Reaper treasury funds permissionlessly so that an administrator can perform
one of a few preset actions which include the following:
Withdraw Funds from Treasury Contract: https://ftmscan.com/address/0x0e7c5313E9BB80b654734d9b7aB1FB01468deE3b#writeContract
Liquidate funds to USDC using Spookyswap
Liquidate funds to USDC-FTM Spooky LP (Sell half, pair in Spookyswap)
BONUS - $500: Liquidate funds to either Fantom Conservatory of Music or Steady Beets Beethoven position.
Send USDC to Remitter: https://ftmscan.com/address/0xa68EdaE6eA103A03021B08C4c56eb9263a93CD64
Send any token to the Byte Masons Multisig: 0x111731A388743a75CF60CCA7b140C58e41D83635

2. Administrators must be given ability to call all functions above without being able to steal funds
3. Multisig must own contract and be able to set and remove administrators as well as manage funds arbitrarily
4. Contract should have adequate safety rails to prevent Admin from doing damage, whether accidentally or maliciously
5. Analyze contracts with Slither, Fuzz with Echidna, and outline all vulnerability the Admin would be able to exploit in the final implementation 

Notes:

Risks:
