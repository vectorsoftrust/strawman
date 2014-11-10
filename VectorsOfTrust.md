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

### Credential Binding

The Credential Binding dimension defines how strongly the primary credential - the one presented by the user to the IdP - can be verified by the IdP and trusted to be presented by the party represented by a given credential. In other words, this dimension describes how likely it is that the right person is presenting the credential to the identity provider, and how easily that credential could be spoofed or stolen.

### Assertion Presentation

The Assertion Presentation dimension defines how well the given digital identity can be communicated across the network without information leaking to unintended parties, and without spoofing. In other words, this dimension describes how likely it is that a given digital identity asserted was actually asserted by a given identity provider for a given transaction.


## Combining the dimensions

All three of these dimensions (and others, as they are defined in extension work) can be combined into a single vector that can be communicated across the wire.

It is vitally important that when doing such communication of the vector that the components of the vector themselves always be individually available and that no attempt is made to "collapse" the vector into a single value.

### Communicating and processing the vector



### In OpenID Connect

### In SAML

## Discovery and verification of IdP aspects

### Operational Management

### Trustmark