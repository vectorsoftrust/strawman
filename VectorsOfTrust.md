# Vectors of Trust

A straw man proposal by Justin Richer and Leif Johannson.

Published on the IETF Vectors of Trust (vot) list: https://www.ietf.org/mailman/listinfo/vot

## Background

The legacy NIST special publication 800-63 defines a linear scale "Level of Assurance" measure that combines multiple attributes about an identity transaction. This work seeks to decompose the elements of the transaction in a way that they can be independently communicated from an Identity Provider to a Relying Party, allowing trust, authentication, and authorization decisions to be made.

### Basic Construct

The term *Vectors of Trust* is based on the mathematical construct of a `Vector`, which is defined as an item composed of multiple independent `scalar` values. A vector allows for expression and comparison in a multi-dimensional space.

An important goal for this work is to balance the need for simplicity (particularly on the part of the relying party) with the need for expressiveness. As such, this vector construct is designed to be composable and extensible. 

## Components

This specification defines three independent dimensions: *identity proofing*, *credential binding*, and *assertion presentation*. Other dimensions are likely to be desired in certain circumstances.

### Identity Proofing

The Identity Proofing dimension defines, overall, how strongly the set of identity attributes have been verified and vetted, and how strongly they are tied to a particular credential set. In other words, this dimension describes how likely it is that a given digital identity corresponds to a particular real-world person.

This dimension shall be represented by the "P" demarcator and one of the following numeric values:

* 0: No proofing is done, data is not guaranteed to be persistent across sessions
* 1: Attributes are self-asserted but consistent over time, potentially pseudonymous
* 2: Identity has been proofed either in person or remotely using trusted mechanisms (such as social proofing)
* 3: There is a legal or contractual relationship between the identity provider and the identified party (such as signed/notarized documents, employment records)

### Credential Binding

The Credential Binding dimension defines how strongly the primary credential - the one presented by the user to the IdP - can be verified by the IdP and trusted to be presented by the party represented by a given credential. In other words, this dimension describes how likely it is that the right person is presenting the credential to the identity provider, and how easily that credential could be spoofed or stolen.

This dimension shall be represented by the "C" demarcator and one of the following numeric values:

* 0: No credential is used / anonymous public service / simple session cookies (with nothing else)
* 1: Shared secret such as a username and password combination
* 2: Known/trusted device
* 3: Proof of key possession, shared key
* 4: Proof of key possession, asymmetric key
* 5: Sealed hardware token / trusted biometric / TPM-backed keys

Note that multiple factors will need to be communicated here, often simultaneously when MFA is used. Also note that there are many, many forms of primary credential out there, and that each one should **NOT** be given a distinct value in this list.


### Assertion Presentation

The Assertion Presentation dimension defines how well the given digital identity can be communicated across the network without information leaking to unintended parties, and without spoofing. In other words, this dimension describes how likely it is that a given digital identity asserted was actually asserted by a given identity provider for a given transaction.

This dimension shall be represented by the "A" demarcator and one of the following values:

* 0: No protection / unsigned bearer identifier (such as a session cookie)
* 1: Signed and verifiable token, passed through the browser
* 2: Signed and verifiable token, passed through a back channel
* 3: Token encrypted to the RP's key and audience protected


## Combining the dimensions

All three of these dimensions (and others, as they are defined in extension work) can be combined into a single vector that can be communicated across the wire.

It is vitally important that when doing such communication of the vector that the components of the vector themselves always be individually available and that no attempt is made to "collapse" the vector into a single value without also presenting the constituent dimensions as well.

### Communicating and processing the vector

The vector shall be represented as a colon-separated list of vector components, such as:

P1:C3:A2

Which translates to pseudonymous, proof of shared key, signed back-channel verified token.

### In OpenID Connect

The client can request a set of acceptable VoT values with the "amr" claim request. The server will respond with the "acr" claim containing the vector value in the ID token:

```json
{
  "iss":"https://idp.example.com/",
  "sub":"jondoe1234",
  "acr":"P1:C3:A2"
}
```

### In SAML

> ***SAML example has been omitted for sanity sake***

## Discovery and verification of IdP aspects

There are many aspects of the trustworthiness of an IdP that won't change on a per-transaction basis, but instead influence the trust placed in the values

### Operational Management

Operational management considerations such as controlled access to server clusters and disaster recovery will be accessible from a .well-known location based on the IdP's issuer URL in machine-readable format.

### Trustmark

The trustmark conveys the root of trustworthiness about the claims and assertions made by the IdP. The IdP will make its trustmark available from a .well-known location based on its issuer URL, such as the openid-configuration document:


```json
{

 "iss": "https://idp.example.org/",
 "trustmark": "https://trustmark-provider.org/csp-123412"
 ...

}
```
 

The URI given in this document would contain information about which vectors the IdP is allowed to claim, according to the trustmark provider:

 
```json
{

  "iss": "https://idp.example.org/",
  "P": [3],
  "C": [1, 2, 3],
  "A": [2, 3],
  "O": [1, 4]
}
```

A client wishing to check the claims made by an IdP can fetch the information from the trustmark provider about what claims the IdP is allowed to make in the first place.