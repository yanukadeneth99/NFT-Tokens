
;; nft-tokens
;; NFT Based contract on Stacks

;; Forcing trait
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; Defining NFT Tokens
(define-non-fungible-token nft-tokens uint)

;; constants
(define-constant contract-owner tx-sender) ;; Keeps Track of the Contract Owner
(define-constant err-owner-only (err u100)) ;; Triggered when an action is called by anyone other than the contract owner
(define-constant err-not-token-owner (err u101)) ;; Triggered when an action is called by anyone other than the token owner

;; data maps and vars
(define-data-var last-token-id uint u0) ;; Last Token ID

;; read only functions
;; Return the Last token ID in uint
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

;; Returns the Token URI, none for now
(define-read-only (get-token-uri (token-id uint))
  (ok none)
)

;; Returns the Owner in Principal
(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? nft-tokens token-id))
)

;; private functions
;;

;; public functions
;; Transfer Tokens to another principal address
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin  
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (nft-transfer? nft-tokens token-id sender recipient)
  )
)

;; Mint new tokens, only the owner
(define-public (mint (recipient principal))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (nft-mint? nft-tokens token-id recipient))
    (var-set last-token-id token-id)
    (ok token-id)
  )
)
