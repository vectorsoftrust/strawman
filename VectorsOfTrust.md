---
title: Vectors of Trust Strawman
abbrev: VoT
docname: draft-vot-straman-00
date: 2014-11-11
category: info
ipr: trust200902
area: Security
wg: General
kw: Internet-Draft
cat: info
stand_alone: yes
pi: [toc, sortrefs, symrefs]
author:
 - 
    ins: L. Johansson
    name: Leif Johansson
    email: leifj@sunet.se
    org: SUNET
 -
    ins: J. Richer
    name: Justin Richer
    email: jricher@mitre.org
    org: MITRE
normative:
  RFC2119:
  
--- abstract

This document defines a mechanism for describing and signaling those aspects that go into a determination of trust placed in a digital identity transaction.

--- middle

# Terminology          {#Terminology}

In this document, the key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL"
are to be interpreted as described in BCP 14, RFC 2119 {{RFC2119}}.

# Introduction

This document defines a mechanism for describing and signaling those aspects that go into a determination of trust placed in a digital identity transaction.

This document is being discussed on the IETF non-WG Vectors of Trust (vot) list: https://www.ietf.org/mailman/listinfo/vot

## Background

The NIST special publication 800-63 defines a linear scale "Level of Assurance" measure that combines multiple attributes about an identity transaction into a single measure of the level of trust a relying party should place on an identity transaction. 

Over the last few years several trust frameworks profiling SP 800-63 have emerged and as the number of such profiles grow, interoperability becomes increasingly problematic. Interoperability between trust frameworks is critical in order to support transactions between identity providers and relying parties that are part of multiple trust frameworks.

This work seeks to decompose the elements of the measure in a way that they can be independently communicated from an Identity Provider to a Relying Party, making comparison between trust frameworks easier.

### The Abstract Identity Architecture

This document assumes the following model:

`The identity subject` (aka user) is associated with an `identity provider` which acts as a trusted 3rd party on behalf of the user wrt to a `relying party` by making `identity assertions` about the user to the relying party. 

The real-world person represented by the identity subject is in possession of a (cryptographic) `credential` bound to the user by (an agent of) identity provider in such a way that the binding between the credential and the real-world user is a representation of the `identity proofing` process performed by the (agent of) the identity provider to verify the identity of the real-world person.

### Component Architecture

The term *Vectors of Trust* is based on the mathematical construct of a `Vector`, which is defined as an item composed of multiple independent `scalar` values. A vector is a set of coordinates that specifies a point in a (multi-dimensional) cartesian coordinate space. The reader is encouraged to think of a vector of trust as a point in a coordinate system, in the simples form (described below) a 3 dimensional space that is intended to be a recognizable, if somewhat elided, model of identity subject trust.

An important goal for this work is to balance the need for simplicity (particularly on the part of the relying party) with the need for expressiveness. As such, this vector construct is designed to be composable and extensible.

#### Composability

All components of the vector construct must be orthogonal in the sense that no aspect of a component overlap an aspect of another component.

#### Extensibility

The vector construct support two forms of extensibility: 
* add a component that is orthogonal (in the sense of the previous section) to all other components. 
* describe an aspect of an existing component which can be elided from the component without affecting other aspects.

An example of the first type might be "liability limits", a measure of how much liability the identity provider or relying party is willing to accept in relationship with the transaction or "incident response", a measure of how the identity provider or relying party is willing to handle a request to share information related to security incidents.

#### Core Components

This specification defines three orthogonal components: *identity proofing*, *credential binding*, and *assertion presentation*. These dimentions (as described below) are intentionally elided and SHOULD be combined with with other information to form trust frameworks can can be used as a basis for audits of identity providers and relying parties.

We hope and expect the owners of such trust frameworks to consider this specification as a baseline on which to build.

### Identity Proofing

The Identity Proofing dimension defines, overall, how strongly the set of identity attributes have been verified and vetted, and how strongly they are tied to a particular credential set. In other words, this dimension describes how likely it is that a given digital identity corresponds to a particular (real-world) identity subject.

This dimension shall be represented by the "P" demarcator and one of the following numeric values:

**TODO/leifj** - do we want to turn this into real normative language?

* 0: No proofing is done, data is not guaranteed to be persistent across sessions
* 1: Attributes are self-asserted but consistent over time, potentially pseudonymous
* 2: Identity has been proofed either in person or remotely using trusted mechanisms (such as social proofing)
* 3: There is a legal or contractual relationship between the identity provider and the identified party (such as signed/notarized documents, employment records)

### Credential Binding

Below we use the term "credential" to denote the credential used by the identity subject to authenticate to the identity provider.

The Credential Binding dimension defines how strongly the credential can be verified by the IdP and trusted to be presented by the party represented by a given credential. In other words, this dimension describes how likely it is that the right person is presenting the credential to the identity provider, and how easily that credential could be spoofed or stolen.

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
* 3: Token encrypted to the relying partys key and audience protected


## Combining the dimensions

All three of these dimensions (and others, as they are defined in extension work) can be combined into a single vector that can be communicated across the wire.

It is vitally important that when doing such communication of the vector that the components of the vector themselves always be individually available and that no attempt is made to "collapse" the vector into a single value without also presenting the constituent dimensions as well.

### Communicating and processing the vector

The vector shall be represented as a colon-separated list of vector components, such as:

P1:C3:A2

Which translates to pseudonymous, proof of shared key, signed back-channel verified token.

### In OpenID Connect

The client can request a set of acceptable VoT values with the "amr" claim request. The server will respond with the "acr" claim containing the vector value in the ID token:

~~~~~~~~~~json
{
  "iss":"https://idp.example.com/",
  "sub":"jondoe1234",
  "acr":"P1:C3:A2"
}
~~~~~~~~~~

### In SAML

In SAML a VoT vector is communicated as an AuthenticationContextClassRef, a sample definition of which might look something like this:

~~~~~~~~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema
     targetNamespace="urn:x-vot:P1:C3:A2"
     xmlns:xs="http://www.w3.org/2001/XMLSchema" 
     xmlns="urn:x-vot:P1:C3:A2"
     finalDefault="extension"
     blockDefault="substitution"
     version="2.0">
     <xs:redefine 
         schemaLocation="saml-schema-authn-context-loa-profile.xsd"/>
 <xs:annotation>
    <xs:documentation>VoT vector P1:C3:A2</xs:documentation>
 </xs:annotation>
 <xs:complexType name="GoverningAgreementRefType">
    <xs:complexContent>
       <xs:restriction base="GoverningAgreementRefType">
          <xs:attribute name="governingAgreementRef"
             type="xs:anyURI"
             fixed="draft-ietf-vot-this-document-00.txt"
             use="required"/>
       </xs:restriction>
    </xs:complexContent>
 </xs:complexType>
 </xs:redefine>
</xs:schema>
~~~~~~~~~~
{: #accref title="SAML AuthnContextClassRef Example" }
 

## Discovery and verification of IdP aspects

There are many aspects of the trustworthiness of an IdP that will not vary on a per-transaction basis, but instead influence the trust placed in the values

### Operational Requirements

Operational management considerations such as controlled access to server clusters and disaster recovery will be accessible from a .well-known location based on the IdP's issuer URL in machine-readable format.

### Trustmark

The trustmark conveys the root of trustworthiness about the claims and assertions made by the IdP. The IdP will make its trustmark available from a .well-known location based on its issuer URL, such as the openid-configuration document:


~~~~~~~~~~json
{

 "iss": "https://idp.example.org/",
 "trustmark": "https://trustmark-provider.org/csp-123412"
 ...

}
~~~~~~~~~~
 

The URI given in this document would contain information about which vectors the IdP is allowed to claim, according to the trustmark provider:

 
~~~~~~~~~~json
{

  "iss": "https://idp.example.org/",
  "P": [3],
  "C": [1, 2, 3],
  "A": [2, 3],
  "O": [1, 4]
}
~~~~~~~~~~

A client wishing to check the claims made by an IdP can fetch the information from the trustmark provider about what claims the IdP is allowed to make in the first place.

--- back

