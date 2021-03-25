package main

import (
	"context"
	"os"
	"os/signal"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"

	"github.com/gotd/td/telegram"
)

func run(ctx context.Context) error {
	logger, _ := zap.NewProduction(zap.IncreaseLevel(zapcore.DebugLevel))
	defer func() { _ = logger.Sync() }()

	return telegram.BotFromEnvironment(ctx, telegram.Options{
		Logger: logger,
	}, func(ctx context.Context, client *telegram.Client) error {
		logger.Info("Initialized")
		return nil
	}, telegram.RunUntilCanceled)
}

func main() {
	// Env:
	//  BOT_TOKEN
	//  APP_ID
	//  APP_HASH
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	if err := run(ctx); err != nil {
		panic(err)
	}
}
