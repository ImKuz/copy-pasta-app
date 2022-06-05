//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: catalog.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Usage: instantiate `Catalog_SourceClient`, then call methods of this protocol to make API calls.
public protocol Catalog_SourceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Catalog_SourceClientInterceptorFactoryProtocol? { get }

  func fetch(
    _ request: Catalog_Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<Catalog_Empty, Catalog_Catalog>
}

extension Catalog_SourceClientProtocol {
  public var serviceName: String {
    return "Catalog.Source"
  }

  /// Unary call to fetch
  ///
  /// - Parameters:
  ///   - request: Request to send to fetch.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func fetch(
    _ request: Catalog_Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Catalog_Empty, Catalog_Catalog> {
    return self.makeUnaryCall(
      path: "/Catalog.Source/fetch",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makefetchInterceptors() ?? []
    )
  }
}

public protocol Catalog_SourceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'fetch'.
  func makefetchInterceptors() -> [ClientInterceptor<Catalog_Empty, Catalog_Catalog>]
}

public final class Catalog_SourceClient: Catalog_SourceClientProtocol {
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Catalog_SourceClientInterceptorFactoryProtocol?

  /// Creates a client for the Catalog.Source service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Catalog_SourceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// To build a server, implement a class that conforms to this protocol.
public protocol Catalog_SourceProvider: CallHandlerProvider {
  var interceptors: Catalog_SourceServerInterceptorFactoryProtocol? { get }

  func fetch(request: Catalog_Empty, context: StatusOnlyCallContext) -> EventLoopFuture<Catalog_Catalog>
}

extension Catalog_SourceProvider {
  public var serviceName: Substring { return "Catalog.Source" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "fetch":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Catalog_Empty>(),
        responseSerializer: ProtobufSerializer<Catalog_Catalog>(),
        interceptors: self.interceptors?.makefetchInterceptors() ?? [],
        userFunction: self.fetch(request:context:)
      )

    default:
      return nil
    }
  }
}

public protocol Catalog_SourceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'fetch'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makefetchInterceptors() -> [ServerInterceptor<Catalog_Empty, Catalog_Catalog>]
}
