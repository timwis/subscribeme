defmodule DataDigest.Digests do
  @moduledoc """
  The Digests context.
  """

  import Ecto.Query, warn: false
  alias DataDigest.Repo

  alias DataDigest.Digests.Digest
  alias DataDigest.Accounts.User

  @doc """
  Returns the list of digests.

  ## Examples

      iex> list_digests()
      [%Digest{}, ...]

  """
  def list_digests do
    Digest
    |> Repo.all()
    |> preload_user()
  end

  def list_user_digests(%User{} = user) do
    Digest
    |> user_digests_query(user)
    |> Repo.all()
    |> preload_user()
  end

  @doc """
  Gets a single digest.

  Raises `Ecto.NoResultsError` if the Digest does not exist.

  ## Examples

      iex> get_digest!(123)
      %Digest{}

      iex> get_digest!(456)
      ** (Ecto.NoResultsError)

  """
  def get_digest!(id) do
    Digest
    |> Repo.get!(id)
    |> preload_user()
  end

  def get_user_digest!(%User{} = user, id) do
    from(d in Digest, where: d.id == ^id)
    |> user_digests_query(user)
    |> Repo.one!()
    |> preload_user()
  end

  @doc """
  Creates a digest.

  ## Examples

      iex> create_digest(%{field: value})
      {:ok, %Digest{}}

      iex> create_digest(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_digest(%User{} = user, attrs \\ %{}) do
    %Digest{}
    |> Digest.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  @doc """
  Updates a digest.

  ## Examples

      iex> update_digest(digest, %{field: new_value})
      {:ok, %Digest{}}

      iex> update_digest(digest, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_digest(%Digest{} = digest, attrs) do
    digest
    |> Digest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Digest.

  ## Examples

      iex> delete_digest(digest)
      {:ok, %Digest{}}

      iex> delete_digest(digest)
      {:error, %Ecto.Changeset{}}

  """
  def delete_digest(%Digest{} = digest) do
    Repo.delete(digest)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking digest changes.

  ## Examples

      iex> change_digest(digest)
      %Ecto.Changeset{source: %Digest{}}

  """
  def change_digest(%User{} = user, %Digest{} = digest) do
    digest
    |> Digest.changeset(%{})
    |> put_user(user)
  end

  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end

  defp user_digests_query(query, %User{id: user_id}) do
    from(d in query, where: d.user_id == ^user_id)
  end

  defp preload_user(query) do
    Repo.preload(query, :user)
  end

  alias DataDigest.Digests.Subscriber

  @doc """
  Returns the list of subscribers.

  ## Examples

      iex> list_subscribers()
      [%Subscriber{}, ...]

  """
  def list_subscribers do
    Subscriber
    |> Repo.all()
    |> preload_digest()
  end

  def list_digest_subscribers(%Digest{} = digest) do
    Subscriber
    |> digest_subscribers_query(digest)
    |> Repo.all()
    |> preload_digest()
  end


  @doc """
  Gets a single subscriber.

  Raises `Ecto.NoResultsError` if the Subscriber does not exist.

  ## Examples

      iex> get_subscriber!(123)
      %Subscriber{}

      iex> get_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscriber!(id) do
    Subscriber
    |> Repo.get!(id)
    |> preload_digest()
  end

  def get_digest_subscriber!(%Digest{} = digest, id) do
    from(s in Subscriber, where: s.id == ^id)
    |> digest_subscribers_query(digest)
    |> Repo.one!()
    |> preload_digest()
  end

  @doc """
  Creates a subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscriber(%Digest{} = digest, attrs \\ %{}) do
    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> put_digest(digest)
    |> Repo.insert()
  end

  @doc """
  Updates a subscriber.

  ## Examples

      iex> update_subscriber(subscriber, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(subscriber, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscriber(%Subscriber{} = subscriber, attrs) do
    subscriber
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Subscriber.

  ## Examples

      iex> delete_subscriber(subscriber)
      {:ok, %Subscriber{}}

      iex> delete_subscriber(subscriber)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscriber(%Subscriber{} = subscriber) do
    Repo.delete(subscriber)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscriber changes.

  ## Examples

      iex> change_subscriber(subscriber)
      %Ecto.Changeset{source: %Subscriber{}}

  """
  def change_subscriber(%Digest{} = digest, %Subscriber{} = subscriber) do
    subscriber
    |> Subscriber.changeset(%{})
    |> put_digest(digest)
  end

  defp put_digest(changeset, digest) do
    Ecto.Changeset.put_assoc(changeset, :digest, digest)
  end

  defp digest_subscribers_query(query, %Digest{id: digest_id}) do
    from(s in query, where: s.digest_id == ^digest_id)
  end

  defp preload_digest(query) do
    Repo.preload(query, digest: :user)
  end
end
