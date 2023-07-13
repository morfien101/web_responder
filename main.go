package main

import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/morfien101/web_responder/webserver"
)

var (
	version = "development"

	defaultResponse = `{"healthy":true}`
	defaultPath     = "/_status"

	helpFlag    = flag.Bool("h", false, "Shows help menu.")
	versionFlag = flag.Bool("v", false, "Shows the version.")

	flagTLSCert           = flag.String("cert", "", "TLS certificate.")
	flagTLSKey            = flag.String("key", "", "TLS private key.")
	flagHTTPListenAddress = flag.String("address", "0.0.0.0", "IP address to listen on.")
	flagHTTPListenPort    = flag.Int("port", 8080, "TCP port for HTTP(S) Server")
	flagResponsePayload   = flag.String("response", defaultResponse, "JSON payload for the response")
	flagPath              = flag.String("path", defaultPath, "Path to respond on")
)

func main() {
	flag.Parse()

	if *helpFlag {
		flag.PrintDefaults()
		return
	}

	if *versionFlag {
		fmt.Println(version)
		return
	}

	httpConfig := &webserver.ServerConfig{
		Cert:          *flagTLSCert,
		Key:           *flagTLSKey,
		ListenAddress: fmt.Sprintf("%s:%d", *flagHTTPListenAddress, *flagHTTPListenPort),
		Routes:        map[string][]byte{*flagPath: []byte(*flagResponsePayload)},
	}

	httpsrv := webserver.NewServer(httpConfig)

	signals := make(chan os.Signal, 2)
	// We till the signals package where to send the signals. aka the channel we just made.
	signal.Notify(signals, os.Interrupt, syscall.SIGTERM)

	errChan := make(chan error, 1)
	go func() {
		errChan <- httpsrv.Start()
	}()

	select {
	case <-signals:
		fmt.Println("Got stop signal. Stopting the HTTP Server...")
		err := httpsrv.Stop(5)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	case err := <-errChan:
		fmt.Println(err)
		os.Exit(1)
	}
}
