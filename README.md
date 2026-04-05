# TurboToastify

`turbo_toastify` packages a lightweight toast notification system for Rails applications using Turbo + Stimulus.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "turbo_toastify"
```

Then run:

```bash
bundle install
```

## Usage

Simply add the `<%= turbo_toastify %>` tag to your layout file `app/views/layouts/application.html.erb`. You do **not** need to install any JavaScript or CSS manually.

```erb
<body>
  <%= yield %>
  <%= turbo_toastify %>
</body>
```

Then, assign ordinary flash messages in your controllers to trigger toasts:

```ruby
def create
  @post = Post.create!(post_params)
  redirect_to posts_path, success: "Post created successfully!"
end
```

If you are using Turbo Streams:

```ruby
def update
  @post.update!(post_params)
  respond_to do |format|
    format.turbo_stream do
      # Note: Flash messages assigned before a Turbo Stream response will automatically
      # be rendered if you append the new flash messages to your flash outlet.
      flash.now[:success] = "Updated successfully!"
      
      render turbo_stream: [
        turbo_stream.replace(@post),
        turbo_stream.append("flash-outlet", turbo_toastify)
      ]
    end
  end
end
```

## JavaScript usage

TurboToastify exposes a global object if you wish to trigger toasts manually from your JavaScript code:

```javascript
TurboToastify.success("Saved!")
TurboToastify.error("Failed to save", { autoClose: 8000, theme: "colored" })
TurboToastify.info("Syncing...", { position: "bottom-center", transition: "zoom" })
TurboToastify.warning("Low storage", { theme: "dark", transition: "flip" })
```

